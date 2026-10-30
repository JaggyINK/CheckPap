"""Gentle sequential crawl of prefecture sites, with on-disk cache.
Usage: python3 -I crawl2.py <datadir>
Reads base.json; writes cache/ and crawl2.json (candidates + verification).
"""
import json, sys, re, os, unicodedata, urllib.request, urllib.parse, ssl, time, hashlib
from html.parser import HTMLParser

D = sys.argv[1]
CACHE = os.path.join(D, "cache"); os.makedirs(CACHE, exist_ok=True)
UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
DELAY = float(os.environ.get("DELAY", "3"))
last = [0.0]


def fetch(url):
    h = hashlib.sha1(url.encode()).hexdigest()
    p = os.path.join(CACHE, h + ".json")
    if os.path.exists(p):
        c = json.load(open(p))
        if c["status"] is not None:
            return c["status"], c["final"], c["html"]
    fails = 0
    while True:
        wait = DELAY - (time.time() - last[0])
        if wait > 0: time.sleep(wait)
        last[0] = time.time()
        req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept-Language": "fr-FR,fr;q=0.9"})
        try:
            with urllib.request.urlopen(req, timeout=40) as r:
                st, fin, html = r.status, r.geturl(), r.read().decode("utf-8", "replace")
        except urllib.error.HTTPError as e:
            st, fin, html = e.code, e.geturl() if hasattr(e, "geturl") else url, ""
        except Exception as e:
            print("  conn refused, stop for this site:", url, e, flush=True)
            raise Refused(url)
        json.dump({"url": url, "status": st, "final": fin, "html": html}, open(p, "w"))
        return st, fin, html


class Refused(Exception):
    pass


def norm(s):
    s = unicodedata.normalize("NFD", s or "")
    return "".join(c for c in s if unicodedata.category(c) != "Mn").lower()


class P(HTMLParser):
    def __init__(self):
        super().__init__(); self.links = []; self.cur = None; self.title = ""; self.h1 = ""; self._in = None
    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if tag == "a" and a.get("href"): self.cur = [a["href"], ""]
        if tag in ("title", "h1"): self._in = tag
    def handle_endtag(self, tag):
        if tag == "a" and self.cur: self.links.append((self.cur[0], " ".join(self.cur[1].split()))); self.cur = None
        if tag == self._in: self._in = None
    def handle_data(self, d):
        if self.cur is not None: self.cur[1] += " " + d
        if self._in == "title": self.title += d
        elif self._in == "h1": self.h1 += d


def parse(html):
    p = P()
    try: p.feed(html)
    except Exception: pass
    p.title = " ".join(p.title.split()); p.h1 = " ".join(p.h1.split())
    return p


RDV = re.compile(r"rendez[- ]?vous|\brdv\b")
ETR = re.compile(r"etranger|sejour|immigration")
BAD = re.compile(r"/layout/|/tags/|/var/|/content/download|\.(pdf|png|jpe?g|docx?|odt|xlsx?)$|/Actualites/|/Elections|/layout/set/print|/content/search|/Publications/", re.I)


def score(url, text):
    path = norm(urllib.parse.unquote(urllib.parse.urlparse(url).path)).rstrip("/")
    segs = [s for s in path.split("/") if s]
    t = norm(text)
    if BAD.search(urllib.parse.urlparse(url).path) or not segs:
        return 0
    rdv_p, etr_p = bool(RDV.search(path)), bool(ETR.search(path))
    etr_t = bool(ETR.search(t))
    if rdv_p and (etr_p or etr_t) and len(segs) <= 3 and not re.search(r"medical|permis|ants|election|naturalis", path):
        return 30 - len(segs)
    if etr_p and segs[0].startswith("demarches") and len(segs) <= 2 and not re.search(r"naturalis|asile|ue-eee|citoyen", path):
        return 20 - len(segs)
    if rdv_p and len(segs) <= 2 and not re.search(r"medical|permis|ants|election", path):
        return 10 - len(segs)
    return 0


def site_of(r):
    sites = json.loads(r["site_internet"] or "[]")
    for s in sites:
        if not s.get("libelle"): return s["valeur"]
    return sites[0]["valeur"]


base = json.load(open(os.path.join(D, "base.json")))
codes = [c for c in sorted(base) if c != "975"]
only = sys.argv[2:]
if only: codes = [c for c in codes if c in only]
outp = os.path.join(D, "crawl2.json")
res = json.load(open(outp)) if os.path.exists(outp) else {}
consec = 0
for code in codes:
    if code in res and res[code].get("homeStatus") == 200 and not res[code].get("refused"):
        continue
    try:
        r = base[code]
        home = site_of(r)
        host = urllib.parse.urlparse(home).netloc
        cands = {}
        for s in json.loads(r["site_internet"] or "[]"):
            if s.get("libelle") and s["valeur"] != home:
                cands[s["valeur"]] = s["libelle"]
        st, fin, html = fetch(home)
        info = {"home": home, "homeStatus": st, "homeFinal": fin}
        pages = [(fin, html)] if st == 200 else []
        hubs = []
        for f, h in pages:
            for href, text in parse(h).links:
                full = urllib.parse.urljoin(f, href).split("#")[0].split("?")[0]
                pu = urllib.parse.urlparse(full)
                if pu.scheme in ("http", "https") and pu.netloc == urllib.parse.urlparse(f).netloc:
                    cands.setdefault(full, text)
        # explore rendez-vous hub pages (one level)
        for u, t in list(cands.items()):
            pth = norm(urllib.parse.urlparse(u).path)
            if urllib.parse.urlparse(u).netloc.endswith(".gouv.fr") and RDV.search(pth) and pth.strip("/").count("/") == 0 and len(hubs) < 2:
                hubs.append(u)
        for u in hubs:
            s2, f2, h2 = fetch(u)
            if s2 == 200:
                for href, text in parse(h2).links:
                    full = urllib.parse.urljoin(f2, href).split("#")[0].split("?")[0]
                    pu = urllib.parse.urlparse(full)
                    if pu.scheme in ("http", "https") and pu.netloc == urllib.parse.urlparse(f2).netloc:
                        cands.setdefault(full, text)
        scored = sorted(((score(u, t), u, t) for u, t in cands.items()), key=lambda x: (-x[0], len(x[1])))
        scored = [s for s in scored if s[0] > 0]
        chosen = None; tried = []
        for sc, u, t in scored[:4]:
            s3, f3, h3 = fetch(u)
            p3 = parse(h3)
            heading = norm(p3.title + " " + p3.h1)
            okhost = urllib.parse.urlparse(f3).netloc.endswith(".gouv.fr")
            topical = bool(ETR.search(heading) or RDV.search(heading))
            tried.append({"url": u, "score": sc, "status": s3, "final": f3, "title": p3.title, "h1": p3.h1, "ok": s3 == 200 and okhost and topical})
            if s3 == 200 and okhost and topical:
                chosen = tried[-1]; break
        info.update({"tried": tried, "chosen": chosen})
        res[code] = info
        json.dump(res, open(outp, "w"), ensure_ascii=False, indent=1)
        print(code, st, (chosen or {}).get("final"), "|", (chosen or {}).get("h1"), flush=True)

        consec = 0
    except Refused as e:
        res[code] = {"home": site_of(base[code]), "homeStatus": None, "refused": str(e), "tried": [], "chosen": None}
        json.dump(res, open(outp, "w"), ensure_ascii=False, indent=1)
        consec += 1
        if consec >= 3:
            print("3 sites refused in a row: stopping the whole crawl", flush=True)
            break
