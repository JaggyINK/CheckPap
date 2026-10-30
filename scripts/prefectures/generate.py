"""Generate prefectures.json from verified data.
Usage: python3 -I generate.py <datadir> <output>
"""
import json, sys, os, re, urllib.parse

D, OUT = sys.argv[1], sys.argv[2]
DATE = "2026-10-29"
base = json.load(open(os.path.join(D, "base.json")))
crawl = json.load(open(os.path.join(D, "crawl2.json")))
crawl1 = json.load(open(os.path.join(D, "crawl.json")))
DATE2 = "2026-10-30"  # date of the second, gentle verification pass
subp = json.load(open(os.path.join(D, "subpref.json")))
ann = json.load(open(os.path.join(D, "annpages.json")))
extra = json.load(open(os.path.join(D, "manual_checks.json")))  # verified by hand (e.g. Paris, JS-only site)

# French article before the department name (grammar only; names come from the annuaire)
ART = {
 "01":"de l'","02":"de l'","03":"de l'","04":"des ","05":"des ","06":"des ","07":"de l'","08":"des ","09":"de l'",
 "10":"de l'","11":"de l'","12":"de l'","13":"des ","14":"du ","15":"du ","16":"de la ","17":"de la ","18":"du ",
 "19":"de la ","2A":"de la ","2B":"de la ","21":"de la ","22":"des ","23":"de la ","24":"de la ","25":"du ",
 "26":"de la ","27":"de l'","28":"d'","29":"du ","30":"du ","31":"de la ","32":"du ","33":"de la ","34":"de l'",
 "35":"d'","36":"de l'","37":"d'","38":"de l'","39":"du ","40":"des ","41":"de ","42":"de la ","43":"de la ",
 "44":"de la ","45":"du ","46":"du ","47":"de ","48":"de la ","49":"de ","50":"de la ","51":"de la ",
 "52":"de la ","53":"de la ","54":"de ","55":"de la ","56":"du ","57":"de la ","58":"de la ","59":"du ",
 "60":"de l'","61":"de l'","62":"du ","63":"du ","64":"des ","65":"des ","66":"des ","67":"du ","68":"du ",
 "69":"du ","70":"de la ","71":"de ","72":"de la ","73":"de la ","74":"de la ","76":"de la ","77":"de ",
 "78":"des ","79":"des ","80":"de la ","81":"du ","82":"de ","83":"du ","84":"de ","85":"de la ","86":"de la ",
 "87":"de la ","88":"des ","89":"de l'","90":"du ","91":"de l'","92":"des ","93":"de la ","94":"du ","95":"du ",
 "971":"de la ","972":"de la ","973":"de la ","974":"de ","976":"de ",
}


def sort_key(c):
    if c in ("2A", "2B"):
        return (20, c)
    return (int(c), "")


sources = [
    {"id": "annuaire_api", "publisher": "lannuaire.service-public.gouv.fr",
     "title": "API Annuaire de l'administration et des services publics",
     "url": "https://api-lannuaire.service-public.gouv.fr/explore/dataset/api-lannuaire-administration/api/", "consulted": DATE},
    {"id": "annuaire_dataset", "publisher": "data.gouv.fr",
     "title": "Service-public.gouv.fr - Annuaire de l'administration - Base de données locales",
     "url": "https://www.data.gouv.fr/datasets/service-public-gouv-fr-annuaire-de-ladministration-base-de-donnees-locales", "consulted": DATE},
]
deps, notes = [], []
no_rdv, no_sp, unverified_web = [], [], []


def addr(r):
    a = [x for x in json.loads(r["adresse"]) if x["type_adresse"] == "Adresse"][0]
    street = ", ".join(x.strip() for x in [a["complement1"], a["complement2"], a["numero_voie"], a["service_distribution"]] if x and x.strip())
    return a["nom_commune"].strip(), f"{street}, {a['code_postal']} {a['nom_commune'].strip()}"


for code in sorted([c for c in base if c != "975"], key=sort_key):
    r = base[code]
    lc = code.lower()
    if code == "75":
        name = "Paris"
        pref = {"fr": "Préfecture de police", "en": "Paris Police Prefecture"}
    else:
        assert r["nom"].startswith("Préfecture - ")
        name = r["nom"][len("Préfecture - "):].strip()
        pref = {"fr": "Préfecture " + ART[code] + name, "en": name + " prefecture"}
    city, address = addr(r)
    phones = json.loads(r["telephone"] or "[]")
    phone = re.sub(r"\s+", "", phones[0]["valeur"]) if phones else None
    cr = crawl.get(code) or {}
    website = cr.get("home") or (crawl1.get(code) or {}).get("home")
    web_ok = cr.get("homeStatus") == 200 or (crawl1.get(code) or {}).get("homeStatus") == 200 or (code in extra and extra[code].get("websiteStatus") == 200)
    src_ids = []
    ann_id = f"annuaire_{lc}"
    sources.append({"id": ann_id, "publisher": "lannuaire.service-public.gouv.fr", "title": ann[code]["title"],
                    "url": ann[code]["url"], "consulted": DATE})
    src_ids.append(ann_id)
    d = {"code": code, "name": name, "prefecture": pref, "city": city, "address": address}
    if phone:
        d["phone"] = phone
    if website and web_ok:
        d["website"] = website
    else:
        unverified_web.append(f"{code} {name}")
    chosen = (cr.get("chosen") or {}).get("final")
    title = (cr.get("chosen") or {}).get("title")
    cdate = DATE2
    if code in extra and extra[code].get("appointmentUrl"):
        chosen, title, cdate = extra[code]["appointmentUrl"], extra[code]["appointmentTitle"], DATE
    if chosen:
        d["appointmentUrl"] = chosen
        rid = f"pref_rdv_{lc}"
        sources.append({"id": rid, "publisher": urllib.parse.urlparse(chosen).netloc.removeprefix("www."),
                        "title": title, "url": chosen, "consulted": cdate})
        src_ids.append(rid)
    else:
        no_rdv.append(f"{code} {name}")
    sp = subp[code]
    if sp["status"] == 200 and "résultat(s)" in sp["title"]:
        d["subprefecturesUrl"] = sp["url"]
        sid = f"annuaire_sp_{lc}"
        sources.append({"id": sid, "publisher": "lannuaire.service-public.gouv.fr", "title": sp["title"],
                        "url": sp["url"], "consulted": DATE})
        src_ids.append(sid)
    else:
        no_sp.append(f"{code} {name}")
    d["sources"] = src_ids
    deps.append(d)

assert len(deps) == 101, len(deps)
reviewNotes = []
if no_rdv:
    reviewNotes.append("Départements sans appointmentUrl (aucune page \"Prendre un rendez-vous\" ou \"Étrangers\" trouvée et vérifiée HTTP 200 avec un titre parlant des étrangers, du séjour ou des rendez-vous, ou site ayant refusé la connexion) : " + ", ".join(no_rdv) + ". L'app renvoie au site de la préfecture.")
if no_sp:
    reviewNotes.append("Départements sans subprefecturesUrl : l'annuaire n'y liste aucune sous-préfecture (" + ", ".join(no_sp) + ").")
if unverified_web:
    reviewNotes.append("Champ website omis (site indiqué par l'annuaire mais réponse HTTP 200 non obtenue) : " + ", ".join(unverified_web) + ".")
reviewNotes += extra.get("_notes", []) + notes
out = {"lastVerified": DATE, "sources": sources, "departments": deps, "reviewNotes": reviewNotes}
s = json.dumps(out, ensure_ascii=False, indent=2) + "\n"
assert "—" not in s
open(OUT, "w").write(s)
print("departments", len(deps), "with appointmentUrl", sum(1 for x in deps if "appointmentUrl" in x))
