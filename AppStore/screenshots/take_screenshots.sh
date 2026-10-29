#!/bin/sh
# Captures d'écran pour l'App Store, en français et en anglais.
# Utilisation (depuis la racine du dépôt) : ./AppStore/screenshots/take_screenshots.sh ["Nom du simulateur"]
set -e
cd "$(dirname "$0")/../.."
DEVICE="${1:-iPhone 18 Pro Max}"
BUNDLE=com.jaggyink.checkpap
BUILD_DIR=$(mktemp -d)

xcodebuild build -project CheckPap.xcodeproj -scheme CheckPap -configuration Debug \
  -destination "platform=iOS Simulator,name=$DEVICE" -derivedDataPath "$BUILD_DIR" -quiet
xcrun simctl boot "$DEVICE" 2>/dev/null || true
sleep 5
xcrun simctl install "$DEVICE" "$BUILD_DIR/Build/Products/Debug-iphonesimulator/CheckPap.app"
xcrun simctl status_bar "$DEVICE" override --time "9:41" --batteryState charged --batteryLevel 100 \
  --cellularMode active --cellularBars 4 --wifiBars 3

shoot() { # langue, nom, arguments de lancement...
  lang=$1; name=$2; shift 2
  mkdir -p "AppStore/screenshots/$lang"
  xcrun simctl terminate "$DEVICE" "$BUNDLE" 2>/dev/null || true
  xcrun simctl launch "$DEVICE" "$BUNDLE" -AppleLanguages "($lang)" -appLanguage "$lang" \
    -hasCompletedOnboarding YES -postalCode 94000 -departmentCode 94 "$@" >/dev/null
  sleep 5
  xcrun simctl io "$DEVICE" screenshot "AppStore/screenshots/$lang/$name.png" >/dev/null
  echo "AppStore/screenshots/$lang/$name.png"
}

for lang in fr en; do
  shoot "$lang" 1-actualites -initialTab news
  shoot "$lang" 2-demarches -initialTab procedures
  shoot "$lang" 3-pays -initialTab procedures -openCountry CA
  shoot "$lang" 4-droits -initialTab rights
  shoot "$lang" 5-dossiers -initialTab files
done

xcrun simctl status_bar "$DEVICE" clear
rm -rf "$BUILD_DIR"
