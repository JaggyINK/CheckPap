# Check Pap

Application iOS (SwiftUI, iOS 17 minimum) d'aide aux démarches de séjour des étrangers en France, utilisable dans tous les départements (métropole et outre-mer).

Service indépendant. Les démarches officielles sont gratuites.

## Lancer le projet

1. Ouvrir `CheckPap.xcodeproj` avec Xcode.
2. Choisir un simulateur iPhone en haut de la fenêtre.
3. Cmd+R pour lancer, Cmd+U pour les tests.

En ligne de commande :

```bash
xcodebuild test -project CheckPap.xcodeproj -scheme CheckPap \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro'
```

## Organisation

- `CheckPap/` : code de l'app (dossiers synchronisés : un fichier ajouté ici est automatiquement compilé).
- `CheckPapTests/` : tests (Swift Testing).
- `docs/` : schéma du contenu, sources officielles, fiche App Store.
- `suivi.md` : feuille de route et état d'avancement.
