# Préparer la publication sur l'App Store

Tout ce qu'il faut pour envoyer Check Pap sur TestFlight puis sur l'App Store (phases 10 et 11 de `suivi.md`). Cocher chaque case au fur et à mesure.

## Contenu de ce dossier

| Fichier | À quoi il sert |
|---|---|
| `metadata/fr.md`, `metadata/en.md` | Textes de la fiche App Store (nom, sous-titre, description, mots-clés...) à copier dans App Store Connect |
| `privacy/politique-confidentialite.md`, `privacy/privacy-policy.md` | Politique de confidentialité (français, anglais) |
| `privacy/app-privacy-answers.md` | Réponses au questionnaire "Confidentialité de l'app" et à la classification par âge |
| `site/` | Pages web à publier (assistance + confidentialité) : leurs adresses sont exigées par Apple |
| `review-notes.md` | Notes pour l'équipe de vérification d'Apple (en anglais) |
| `screenshots/take_screenshots.sh` | Génère les captures d'écran en français et en anglais |

Le manifeste de confidentialité exigé par Apple est dans l'app elle-même : `CheckPap/Resources/PrivacyInfo.xcprivacy` (il doit être inclus dans l'app, pas dans ce dossier).

## Avant le premier envoi

- [ ] **Relecture du contenu** par une personne compétente (association, juriste) : les 16 démarches, les droits et les actualités sont rédigés depuis les sources officielles mais personne ne les a encore relus. Apple vérifie particulièrement les apps qui touchent aux démarches publiques.
- [ ] **Traductions anglaises** de tous les textes de l'interface (String Catalog) : la fiche est en anglais aussi, l'app doit l'être.
- [ ] **Team et bundle ID** dans Xcode (cible CheckPap > Signing & Capabilities) ; le bundle ID doit être exactement celui de la fiche "Check Pap" dans App Store Connect (provisoire : `com.jaggyink.checkpap`).
- [ ] **Publier les pages web** de `site/` (voir plus bas) et noter leurs adresses.
- [ ] **Remplir `[À COMPLÉTER]`** dans les fichiers (adresse e-mail de contact, nom de l'éditeur).

## Publier les pages web (assistance et confidentialité)

Le plus simple, puisque le dépôt est sur GitHub : GitHub Pages.

1. Sur https://github.com/JaggyINK/CheckPap > Settings > Pages.
2. Source : "Deploy from a branch", branche `main`, dossier `/AppStore/site` n'est pas proposé : choisir `/docs` après avoir copié `AppStore/site/*` dans `docs/site/`, ou créer un petit dépôt public `check-pap-site` avec le contenu de `site/`.
3. Adresses obtenues (à reporter dans App Store Connect) :
   - Assistance : `https://jaggyink.github.io/<dépôt>/`
   - Confidentialité : `https://jaggyink.github.io/<dépôt>/confidentialite.html`

## Captures d'écran

```bash
./AppStore/screenshots/take_screenshots.sh
```

Le script démarre le plus grand iPhone disponible, force une barre d'état propre (9:41, batterie pleine), ouvre chaque onglet en français puis en anglais et enregistre les images dans `AppStore/screenshots/fr/` et `en/`. Apple demande au minimum les captures du plus grand écran iPhone ; les autres tailles sont réduites automatiquement. Vérifier la taille exigée dans App Store Connect au moment de l'envoi.

## Dans App Store Connect

- [ ] Informations de l'app : catégorie principale **Utilitaires**, secondaire **Référence** (à confirmer), langue principale **français**.
- [ ] Tarif : **gratuit**. Disponibilité : tous les pays (les personnes préparent souvent leur venue depuis l'étranger).
- [ ] Confidentialité de l'app : **"Aucune donnée collectée"** (voir `privacy/app-privacy-answers.md`), URL de la politique.
- [ ] Classification par âge : questionnaire (voir `privacy/app-privacy-answers.md`).
- [ ] Fiche française et anglaise : textes de `metadata/`, captures, URL d'assistance.
- [ ] Informations de vérification : coordonnées, notes de `review-notes.md`.

## TestFlight puis App Store

1. Xcode : Version `1.0.0`, Build incrémenté, destination "Any iOS Device", Product > Archive.
2. Organizer : "Validate App", puis "Distribute App" > App Store Connect > Upload.
3. TestFlight : groupe interne (soi-même), puis groupe externe (vérification "Beta App Review", souvent moins de 48 h) avec 5 à 10 personnes concernées.
4. Corriger les retours, renvoyer un build (numéro de build + 1).
5. Version 1.0 : choisir le build, "Ajouter pour vérification", "Soumettre", publication manuelle.
6. Après validation : publier, puis `git tag v1.0.0 && git push --tags`.
