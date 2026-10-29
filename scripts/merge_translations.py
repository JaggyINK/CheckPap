"""Intègre des traductions dans le String Catalog et dans les JSON de contenu.
Utilisation : python3 scripts/merge_translations.py traductions1.json [traductions2.json ...]
Format : { "ui": { "<clé française>": { "<langue>": "..." } },
           "content": { "<fichier>.<chemin vers le texte>": { "<langue>": "..." } } }
Les chemins de contenu : catalog.categories.<id>.title, catalog.procedures.<id>.subtitle,
rights.questions.<id>.options.<id>.label, etc.
"""
import json
import sys

CATALOG = "CheckPap/Resources/Localizable.xcstrings"
CONTENT = "CheckPap/Resources/Content/{}.json"

ui, content = {}, {}
for path in sys.argv[1:]:
    data = json.load(open(path))
    for key, values in data.get("ui", {}).items():
        ui.setdefault(key, {}).update({k: v for k, v in values.items() if v})
    for key, values in data.get("content", {}).items():
        content.setdefault(key, {}).update({k: v for k, v in values.items() if v})

# 1. Interface (String Catalog).
strings_file = json.load(open(CATALOG))
for key, values in ui.items():
    entry = strings_file["strings"].setdefault(key, {})
    localizations = entry.setdefault("localizations", {})
    for language, value in values.items():
        localizations[language] = {"stringUnit": {"state": "translated", "value": value}}
strings_file["strings"] = dict(sorted(strings_file["strings"].items()))
json.dump(strings_file, open(CATALOG, "w"), ensure_ascii=False, indent=2)


# 2. Contenu : on suit le chemin, les tableaux sont parcourus par identifiant.
def find(node, part):
    if isinstance(node, list):
        return next(item for item in node if item.get("id") == part)
    return node[part]


files = {}
for key, values in content.items():
    name, *path = key.split(".")
    if name not in files:
        files[name] = json.load(open(CONTENT.format(name)))
    node = files[name]
    collection_keys = {"categories", "procedures", "subcategories", "questions", "options"}
    i = 0
    while i < len(path) - 1:
        part = path[i]
        node = find(node, part)
        if part in collection_keys:
            node = find(node, path[i + 1])
            i += 1
        i += 1
    node[path[-1]].update(values)
for name, data in files.items():
    json.dump(data, open(CONTENT.format(name), "w"), ensure_ascii=False, indent=2)

print(f"{len(ui)} textes d'interface et {len(content)} textes de contenu intégrés")
