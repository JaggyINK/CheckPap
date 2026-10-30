#!/bin/sh
# Vérifie en quelques secondes que chaque fichier JSON se décode avec les modèles de l'app.
# Affiche l'erreur exacte (fichier, chemin dans le JSON, champ manquant) en cas de problème.
set -e
cd "$(dirname "$0")/.."
TMP_DIR=$(mktemp -d)
cp scripts/check_content.swift "$TMP_DIR/main.swift"
xcrun swiftc -o "$TMP_DIR/check" CheckPap/Models/Content/*.swift "$TMP_DIR/main.swift"
"$TMP_DIR/check" CheckPap/Resources/Content
rm -rf "$TMP_DIR"
python3 scripts/check_translations.py || true
