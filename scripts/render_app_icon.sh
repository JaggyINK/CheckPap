#!/bin/sh
# Génère CheckPap/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png
# à partir du logo défini dans CheckPap/Shared/Brand.swift (une seule source pour le logo).
set -e
cd "$(dirname "$0")/.."
TMP_DIR=$(mktemp -d)
# Le bloc #Preview (fin de Brand.swift) n'existe que dans Xcode : on le retire.
sed '/^#Preview/,$d' CheckPap/Shared/Brand.swift > "$TMP_DIR/Brand.swift"
cp scripts/render_app_icon.swift "$TMP_DIR/main.swift"
xcrun swiftc -o "$TMP_DIR/render" "$TMP_DIR/Brand.swift" "$TMP_DIR/main.swift"
"$TMP_DIR/render" CheckPap/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png
rm -rf "$TMP_DIR"
