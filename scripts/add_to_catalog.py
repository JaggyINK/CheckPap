"""Ajoute une démarche au catalogue, rangée dans sa catégorie et sa sous-catégorie.
Utilisation : python3 scripts/add_to_catalog.py <id> <symbole> <catégorie> <sous-catégorie> "<titre fr>" "<titre en>" "<sous-titre fr>" "<sous-titre en>"
"""
import json
import sys

path = "CheckPap/Resources/Content/catalog.json"
pid, symbol, category, subcategory, title_fr, title_en, sub_fr, sub_en = sys.argv[1:9]
catalog = json.load(open(path))
assert any(c["id"] == category and any(s["id"] == subcategory for s in c["subcategories"]) for c in catalog["categories"]), "catégorie inconnue"
catalog["procedures"] = [p for p in catalog["procedures"] if p["id"] != pid]
catalog["procedures"].append({
    "id": pid, "symbol": symbol,
    "title": {"fr": title_fr, "en": title_en},
    "subtitle": {"fr": sub_fr, "en": sub_en},
    "category": category, "subcategory": subcategory,
})
version, _, build = catalog["contentVersion"].rpartition(".")
catalog["contentVersion"] = f"{version}.{int(build) + 1}"
json.dump(catalog, open(path, "w"), ensure_ascii=False, indent=2)
print(f"{pid} rangé dans {category} > {subcategory}")
