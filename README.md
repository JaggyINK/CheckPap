# Check Pap

Application iOS (SwiftUI, iOS 17 minimum, interface native et sobre avec Liquid Glass pour la navigation sur iOS 26+, 18 langues) qui aide les personnes étrangères en France, et les Français qui partent vivre à l'étranger, à préparer leurs démarches. Utilisable dans toute la France.

Service indépendant. Les démarches officielles sont gratuites. L'app informe et oriente ; elle ne donne pas de conseil juridique et ne promet aucun résultat.

## Ce que fait l'app

Quatre onglets :

| Onglet | Contenu |
|---|---|
| **Actualités** | Ce qui change pour les étrangers (lois, décrets, taxes, délais, aides), publié par l'administration, filtrable par thème. |
| **Démarches** | 16 démarches rangées par catégorie et sous-catégorie, avec recherche. Pour chacune : questions en entonnoir, orientation si la situation ne correspond pas, liste de pièces personnalisée et cochable (pièces inutiles à retirer), étapes guidées à cocher, dates calculées, lieu de dépôt ou de rendez-vous (préfecture trouvée par code postal), rendez-vous enregistré avec calendrier et rappels, fiches "Comment l'obtenir ?", modèles de courriers. |
| **Mes droits** | "1 étranger, 1 solution" : un questionnaire page par page, puis les droits et aides qui peuvent concerner la personne (santé, argent, logement, travail, famille, banque, recours). |
| **Mes dossiers** | Mon titre de séjour (date de fin, dates de renouvellement, rappels), puis les démarches commencées : avancement, rendez-vous enregistré, suppression. |

Catégories de démarches :

- **Titre de séjour** : renouveler, changer de titre ; remplacer un titre perdu, signaler un changement.
- **Famille** : faire venir sa famille, faire voyager son enfant.
- **Nationalité française** : naturalisation, par mariage.
- **Papiers et voyages** : passeport, carte d'identité, venir en France avec un visa, voyager hors de France.
- **Vie en France** : première déclaration d'impôts, garant pour louer (Visale), échange de permis de conduire.
- **S'expatrier** : préparer son départ, 200 fiches pays (motifs de départ, vacances-travail, budget repère en euros et en monnaie locale).

En haut de l'onglet : "Reprendre mes dossiers" et "Les plus demandées".

Tout le contenu est sourcé (lien et date de consultation sur chaque information) et reste en statut "brouillon" tant qu'une personne ne l'a pas relu.

## Lancer le projet

1. Ouvrir `CheckPap.xcodeproj` avec Xcode (pas un fichier `.swift` seul).
2. Choisir un simulateur iPhone en haut de la fenêtre.
3. Cmd+R pour lancer, Cmd+U pour les tests.

En ligne de commande :

```bash
xcodebuild test -project CheckPap.xcodeproj -scheme CheckPap \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

Options de lancement utiles (captures d'écran, vérifications) :

```bash
xcrun simctl launch booted <bundle-id> -initialTab rights          # news, procedures, rights, files
xcrun simctl launch booted <bundle-id> -openCountry CA             # ouvre une fiche pays (version Debug)
```

## Organisation du code

```
CheckPap/
├── App/                 point d'entrée, onglets, navigation (Router, RouteDestination)
├── Models/
│   ├── Content/         structures lues dans les JSON (démarches, conditions, droits, pays...)
│   └── Persistence/     données de l'utilisateur (SwiftData)
├── Services/            chargement du contenu, moteur de règles, calcul du budget
├── Features/            un dossier par écran : News, Procedures, Procedure, Questionnaire,
│                        Checklist, Guidance, Letters, Rights, Countries, MyFiles
├── Shared/              composants réutilisables, animations, logo, effet verre
└── Resources/Content/   tout le contenu en JSON (aucune règle administrative dans le code)
CheckPapTests/           moteur de règles, budget, courriers, conformité du contenu
docs/                    schéma du contenu, inventaire des sources
scripts/                 contrôle du contenu, ajout au catalogue, génération de l'icône
suivi.md                 feuille de route et journal
AppStore/                tout pour la publication : fiche, confidentialité, captures, notes pour Apple
```

## Contenu

| Fichier | Rôle |
|---|---|
| `catalog.json` | Catégories, sous-catégories et liste des démarches |
| `procedures/*.json` | Une démarche par fichier |
| `help.json` | Contacts d'aide, modèles de courriers, fiches pratiques |
| `news.json` | Actualités |
| `rights.json`, `rights_*.json` | Questions de profil et droits |
| `countries.json`, `countries_details.json`, `countries_budget.json` | Pays, fiches détaillées, budget et taux de change |

Le format exact est décrit dans `docs/content-schema.md`.

## Scripts

```bash
./scripts/check_content.sh          # décode tous les JSON avec les vrais modèles, sans simulateur
python3 scripts/add_to_catalog.py   # range une nouvelle démarche dans le catalogue
./scripts/render_app_icon.sh        # régénère l'icône depuis le logo SwiftUI
python3 scripts/merge_translations.py fichier.json   # intègre des traductions (interface et contenu)
./AppStore/screenshots/take_screenshots.sh           # captures App Store en français et en anglais
# Préfectures : voir scripts/prefectures/README.md
```
