"""Signale les textes de l'interface qui n'ont pas de traduction dans toutes les langues de l'app.
Utilisation : python3 scripts/check_translations.py   (code de sortie 1 s'il en manque)
"""
import json
import sys

LANGUAGES = ["en", "ar", "bn", "hi", "zh-Hans", "ru", "id", "th", "tr", "uk", "fa", "ps", "ur", "ta", "ti", "pt", "es"]
strings = json.load(open("CheckPap/Resources/Localizable.xcstrings"))["strings"]
missing = {
    key: sorted(set(LANGUAGES) - set(value.get("localizations", {})))
    for key, value in strings.items()
    if value.get("shouldTranslate") is not False and set(LANGUAGES) - set(value.get("localizations", {}))
}
if missing:
    print(f"TRADUCTIONS MANQUANTES : {len(missing)} textes")
    for key, languages in list(missing.items())[:20]:
        print(f"  - {key[:70]} ({len(languages)} langues)")
    sys.exit(1)
print(f"OK      traductions : {len(strings)} textes dans {len(LANGUAGES) + 1} langues")
