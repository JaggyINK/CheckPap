# Check Pap : suivi du projet

Application iOS d'aide aux démarches administratives des étrangers en France.
Ce fichier est la feuille de route : on coche chaque tâche quand son critère de "terminé" est rempli.

Dernière mise à jour du plan : 29/10/2026.
État constaté sur le Mac à cette date : macOS 27.2, Xcode 27.1 déjà installé.

---

## Sommaire

- [Journal](#journal)
- [Comment utiliser ce fichier](#comment-utiliser-ce-fichier)
- [Décisions](#décisions)
- [Phase 0 : prérequis et installation](#phase-0--prérequis-et-installation)
- [Phase 1 : création du projet dans Xcode](#phase-1--création-du-projet-dans-xcode)
- [Phase 2 : modèle de données et fichiers JSON](#phase-2--modèle-de-données-et-fichiers-json)
- [Phase 3 : écran de choix de la langue](#phase-3--écran-de-choix-de-la-langue)
- [Phase 4 : QCM](#phase-4--qcm)
- [Phase 5 : liste à cocher](#phase-5--liste-à-cocher)
- [Phase 6 : calendrier et notifications](#phase-6--calendrier-et-notifications)
- [Phase 7 : traductions](#phase-7--traductions)
- [Phase 8 : écrans légaux et mentions](#phase-8--écrans-légaux-et-mentions)
- [Phase 9 : tests](#phase-9--tests)
- [Phase 10 : préparation de la soumission App Store](#phase-10--préparation-de-la-soumission-app-store)
- [Phase 11 : TestFlight puis App Store](#phase-11--testflight-puis-app-store)
- [Questions ouvertes](#questions-ouvertes)

| Phase | Tâches | Durée estimée |
|---|---|---|
| 0 | 9 | 3 h 30 |
| 1 | 5 | 3 h 30 |
| 2 | 8 | 11 h |
| 3 | 5 | 6 h |
| 4 | 7 | 10 h |
| 5 | 6 | 8 h |
| 6 | 6 | 8 h |
| 7 | 5 | 5 h 30 |
| 8 | 5 | 5 h |
| 9 | 6 | 8 h |
| 10 | 9 | 9 h |
| 11 | 7 | 5 h (+ délais Apple) |
| **Total** | **78** | **environ 82 h** |

---

## Journal

**29/10/2026**
- Environnement vérifié : macOS 27.2, Xcode 27.1, simulateurs iOS 27.0 et 27.1. Homebrew et `gh` absents ; pas nécessaires pour l'instant.
- Le projet a été créé **par fichiers** au lieu de l'assistant Xcode (tâche 1.1 adaptée) : `CheckPap.xcodeproj` avec dossiers synchronisés, cible app + cible de tests, schéma partagé.
- Réglages appliqués (tâche 1.2) : iOS 17, iPhone, portrait, nom affiché "Check Pap", version 0.1.0 build 1, signature automatique, chiffrement non soumis à déclaration. **Reste à faire à la main : choisir la Team dans Signing & Capabilities et vérifier le bundle ID** (provisoire : `com.jaggyink.checkpap`).
- Premier écran en Liquid Glass, mention d'indépendance, String Catalog fr/en, premier test : compilation et tests OK sur iPhone 18 Pro (iOS 27.1).
- Inventaire des sources officielles en cours : `docs/sources/inventaire-demarches.md`.
- **Changement de périmètre : l'app couvre toute la France**, plus seulement le Val-de-Marne. Plan, README et recherche de sources adaptés.
- À faire : installer un simulateur iOS 17 (tâche 0.4), et choisir la Team dans Xcode (tâche 0.7).
- Logo vectoriel (deux feuilles et une coche) et icône générés depuis le code : `scripts/render_app_icon.sh`.
- 4 démarches complètes en JSON, sourcées et à jour au 29/10/2026 : renouvellement, changement de statut, naturalisation, duplicata. Questions en entonnoir, pièces avec exemples et astuces, étapes guidées, dates calculées.
- Orientation quand la situation ne correspond pas (`outcomes`) : explication sans verdict, pistes, contacts, courriers.
- `help.json` : 6 contacts d'aide et 4 modèles de courriers (e-mail ou recommandé), remplis avec les informations de la personne, gardées sur le téléphone.
- Code découpé en petits fichiers par fonctionnalité (`Features/...`, `Shared/Components`, `Shared/Animations`).
- 22 tests verts : moteur de règles, courriers, conformité du contenu (sources, domaines, traductions, garde-fous). Contrôle rapide hors simulateur : `./scripts/check_content.sh`.
- **Contenu au statut `draft`** : relecture humaine indispensable avant publication (voir `reviewNotes` de chaque fichier). Le décret n°2026-1001 change des délais au 30/10/2026 : à revérifier.
- Reste à faire : traduire en anglais les nouveaux textes de l'interface (String Catalog), écran de choix de la langue et du département.

**29/10/2026 (suite)**
- Logo : initiales "CP" et pastille "validé" en V.
- Chaque pièce dépend de la situation ("Pourquoi cette pièce ?" affiché dans l'app) ; test automatique contre les pièces "seulement si" sans condition.
- Conditions sur les dates (`daysFromToday`) : plus de question "temps restant" en doublon avec la date ; un titre déjà expiré déclenche l'orientation adaptée.
- Fiches pratiques "Comment l'obtenir ?" (e-photo, timbre fiscal, traduction, casier judiciaire...) reliées aux pièces et aux étapes.
- Nouvelles démarches en cours de rédaction : passeport (français ou étranger), visa pour venir en France, voyager de la France vers l'étranger.

**29/10/2026 (fin de journée)**
- Navigation en 4 onglets : Actualités (première page), Démarches, Mes droits, Mes dossiers. Barre d'onglets Liquid Glass sur iOS 26.
- Démarches rangées en catégories et sous-catégories, avec recherche : S'expatrier, Séjour, Nationalité, Identité et voyages, Vie en France.
- 16 démarches : renouvellement, changement de titre, naturalisation, duplicata, passeport, visa pour la France, voyage hors de France, changement d'adresse ou de situation, document de circulation pour mineur, nationalité par mariage, regroupement familial, première déclaration d'impôts, carte d'identité, Visale, échange de permis, préparer son départ à l'étranger.
- Titres des démarches reformulés (verbe d'action, première personne, nom administratif en sous-titre).
- Actualités : 21 articles sourcés (lois, décrets, taxes, aides), filtres par thème.
- Mes droits (1 étranger, 1 solution) : questionnaire page par page, puis 31 droits et aides sourcés.
- S'expatrier : 200 fiches pays (liens vérifiés), 20 fiches détaillées (motifs de départ, visas, coûts), programme vacances-travail selon l'âge, budget repère en fourchette (allocation VIE pour le bas, barème des missions de l'État pour le haut) en euros et en monnaie locale (taux DGFiP du 1er octobre 2026).
- Lettre "impossible de faire la démarche en ligne" corrigée : elle cite exactement la décision du Conseil d'État n° 502860 (rappel du principe, pas d'injonction nationale).
- Garde-fou "promesse" affiné ("Garantie Visale" autorisé) ; liens d'ambassades passés en https.
- 36 tests verts.
- Historique Git : auteur des commits remplacé par le compte GitHub JaggyINK.

**30/10/2026**
- Pièces : bouton "Je n'ai pas besoin de cette pièce", pièces retirées consultables et remettables.
- Étapes : cocher une étape faite, étape en cours mise en avant, suivantes grisées.
- Dossier prêt : écran "Votre dossier est prêt", lieu de dépôt pour chacune des 16 démarches (`appointments`), préfecture trouvée par code postal.
- Rendez-vous enregistré : date, lieu, notes, ajout au calendrier (sans accès complet), rappels la veille et 2 h avant.
- Mes dossiers : suppression d'un dossier (glisser ou appui long).
- Bandeau "Contenu en cours de vérification" retiré (personne ne relit encore).
- S'expatrier : parcours complet pour les personnes étrangères vivant en France (passeport de leur pays, visa selon la nationalité, effet d'une longue absence sur le titre de séjour, réfugiés, impôts, protection sociale), plus d'impasse.
- Mon titre de séjour (onglet Mes dossiers) : date de fin et type de titre, dates de renouvellement calculées avec les règles de la démarche Renouvellement, rappels à 9 h ces jours-là et le jour de la fin de validité.
- Préparer mon départ et Voyager hors de France : nouvelle question "Dans quel pays partez-vous ?" (type `country`) ; la liste affiche une carte "Votre destination" avec le budget repère et le lien vers la fiche pays.
- En cours : annuaire des préfectures (`prefectures.json`).

## Feuille de route après la v1 (demandes de l'utilisatrice)

- [ ] **Annuaire des consulats par nationalité et par lieu** (les fiches pays donnent déjà le lien vers l'ambassade du pays en France) : pour un passeport étranger, indiquer le consulat compétent selon le pays et le département de la personne. Nécessite une source structurée et maintenue (liste des représentations étrangères en France) et l'écran de choix du département (tâche 3.5).
- [x] **Onglet "1 étranger 1 solution"** (première version faite le 29/10/2026) : les droits des étrangers selon leur situation (santé, logement, travail, aides, scolarité, recours...), sur le modèle de "1 jeune 1 solution". Même principe que les démarches : quelques questions, puis les droits et aides qui correspondent, chacun sourcé, avec les services à contacter.

---

## Comment utiliser ce fichier

- Chaque tâche commence par une case `- [ ]`. On la remplace par `- [x]` quand le critère "Terminé quand" est vérifié.
- Une tâche = un commit Git (message du type `feat(4.3): écran de question`).
- "À la main" veut dire : dans l'interface de Xcode, d'App Store Connect ou du Terminal. "En code" veut dire : du Swift ou du JSON écrit dans un fichier.
- Avant chaque tâche de code, on lit d'abord la partie "Concept", puis on écrit le code ensemble.
- Les durées sont des estimations pour un développeur web expérimenté qui découvre Swift. Elles incluent le temps de compréhension.

---

## Décisions

Ces décisions sont prises. On ne les remet pas en question pendant la v1.

**Technique**
- SwiftUI, cible iOS 17 minimum.
- Stockage local avec SwiftData. Pas de compte obligatoire.
- Le contenu (démarches, pièces, liens, traductions) est stocké dans des fichiers JSON : d'abord inclus dans l'app, plus tard chargés depuis un serveur.
- Le code ne contient aucune règle administrative en dur : toutes les conditions viennent du JSON.
- Bouton "Ajouter au calendrier" pour les rendez-vous et les dates limites, via EventKit, sans demander l'accès complet au calendrier.
- Notifications locales de rappel.

**Périmètre de la version 1** (mis à jour le 29/10/2026)
- **Toute la France** : n'importe quel étranger, quel que soit son département, peut utiliser l'app.
- Plusieurs démarches au choix : changement de statut, renouvellement, première demande, naturalisation, etc. La liste exacte dépend de l'inventaire des sources (tâche 2.0).
- Le contenu est en deux couches : un **socle national** (règles, conditions et pièces communes, issues de l'ANEF, de service-public.fr et de Légifrance) et des **précisions locales par préfecture** (rendez-vous, sous-préfecture compétente, pièces ou modalités propres au département).
- L'utilisateur indique son département (ou son code postal) ; l'app lui associe sa préfecture.
- Si les précisions locales d'une préfecture n'ont pas encore été vérifiées, l'app l'affiche clairement et renvoie vers le site de cette préfecture. On n'invente jamais une règle locale.
- Parcours : choix de la langue au premier lancement, puis **choix de la démarche**, puis QCM propre à cette démarche, puis liste personnalisée des documents à fournir, avec liens officiels et explication de la prise de rendez-vous.
- **Toute information vient des sources officielles** : sites nationaux (ANEF, service-public.fr, Légifrance, OFII, interieur.gouv.fr) pour le socle, sites des préfectures (*.gouv.fr) pour les précisions locales, annuaire de l'administration (service-public.fr / data.gouv.fr) pour les coordonnées. Chaque question, condition et pièce du JSON porte au moins une source (URL + date de consultation). Un test bloque tout élément sans source ou dont la source est hors de ces domaines.

**Design**
- Épuré, style Apple "Liquid Glass" (iOS 26+), avec repli automatique sur des matériaux translucides pour iOS 17 à 25.
- Composants système en priorité (NavigationStack, List, Form) : ils adoptent Liquid Glass d'eux-mêmes.
- Couleur d'accent sarcelle, neutre, sans rapport avec les couleurs de l'État.

**Projet**
- Dépôt : https://github.com/JaggyINK/CheckPap
- Aucune dépendance externe : projet Xcode écrit directement, dossiers synchronisés.
- Langue de développement des textes : français.
- La liste est cochable et stockée sur le téléphone.
- Annuaire des consulats pour les passeports : seulement coordonnées et liens, pas de procédure.

**Langues**
- Français et anglais en v1.
- Architecture prête pour d'autres langues : String Catalogs, support de l'arabe (écriture de droite à gauche).
- Sélecteur de langue dans l'app, en plus du réglage iOS.

**Hors version 1**
- Vérification payante des documents, backend, paiement.
- Android (prévu plus tard en Kotlin).

**Garde-fous**
- Aucun logo ni couleur gouvernementale.
- Pas le mot "officiel" pour qualifier l'app (voir [Questions ouvertes](#questions-ouvertes) pour les cas limites).
- Mention visible : "service indépendant, démarches officielles gratuites".
- Jamais de conseil juridique, jamais de promesse de résultat.
- Date de dernière vérification affichée sur chaque fiche.

**Compte et publication**
- Compte Apple Developer actif.
- Nom "Check Pap" déjà réservé dans App Store Connect.

---

## Phase 0 : prérequis et installation

Objectif de la phase : un Mac prêt à compiler, signer et envoyer une app iOS, et un dépôt GitHub en place.

- [x] **0.1 Vérifier macOS et l'espace disque**

**Objectif :** s'assurer que le Mac peut faire tourner la version actuelle de Xcode.

**Étapes :**
1. (À la main, Terminal) Lancer les commandes ci-dessous.
2. Comparer la version de macOS avec la page officielle des prérequis Xcode : https://developer.apple.com/xcode/system-requirements/
3. Vérifier qu'il reste au moins 50 Go libres (Xcode + simulateurs + archives prennent vite 40 Go).

**Commandes :**
```bash
sw_vers                 # version de macOS
df -h /                 # espace disque libre
```

**Fichiers :** aucun.

**Concept :** Xcode est lié à une version minimale de macOS, et Apple impose régulièrement une version minimale du SDK iOS pour envoyer une app sur l'App Store (voir https://developer.apple.com/news/upcoming-requirements/). C'est l'équivalent d'une version de Node imposée par un hébergeur : si on est en retard, l'envoi est refusé.

**Terminé quand :** la version de macOS est compatible avec le dernier Xcode stable et il reste au moins 50 Go libres. (Constaté le 29/10/2026 : macOS 27.2.)

**Durée :** 15 min

---

- [x] **0.2 Installer ou mettre à jour Xcode**

**Objectif :** avoir la dernière version stable de Xcode, licence acceptée et premier lancement fait.

**Étapes :**
1. (À la main) Ouvrir le Mac App Store, chercher "Xcode", installer ou mettre à jour. Ne pas prendre une version bêta.
2. (À la main) Ouvrir Xcode une première fois et laisser installer les composants supplémentaires.
3. (Terminal) Accepter la licence et finaliser le premier lancement avec les commandes ci-dessous.

**Commandes :**
```bash
xcodebuild -version
sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch
```

**Fichiers :** aucun.

**Concept :** Xcode regroupe l'éditeur, le compilateur Swift, les SDK iOS, les simulateurs et les outils de signature. C'est à la fois VS Code, Node, Webpack et un navigateur de test. On ne peut pas développer pour iOS sans lui.

**Terminé quand :** `xcodebuild -version` affiche la version installée sans erreur. (Constaté le 29/10/2026 : Xcode 27.1.)

**Durée :** 15 min si déjà installé, 1 h 30 sinon (téléchargement lourd).

---

- [x] **0.3 Configurer les outils en ligne de commande**

**Objectif :** que `xcodebuild`, `xcrun`, `git` et `swift` pointent vers le bon Xcode.

**Étapes :**
1. (Terminal) Vérifier le chemin actif des outils.
2. S'il ne pointe pas vers `/Applications/Xcode.app/...`, le corriger.
3. (À la main) Dans Xcode > Settings > Locations, vérifier que "Command Line Tools" affiche la bonne version.

**Commandes :**
```bash
xcode-select -p
# si besoin :
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
swift --version
xcrun --find simctl
```

**Fichiers :** aucun.

**Concept :** `xcode-select` choisit quel Xcode est "actif" pour le Terminal, un peu comme `nvm use` choisit la version de Node.

**Terminé quand :** `xcode-select -p` renvoie le chemin de Xcode.app et `swift --version` fonctionne.

**Durée :** 10 min

---

- [ ] **0.4 Installer les simulateurs iOS**

**Objectif :** disposer d'un simulateur récent et d'un simulateur iOS 17 (notre version minimale).

**Étapes :**
1. (À la main) Xcode > Settings > Components : vérifier que la plateforme iOS récente est installée.
2. (À la main) Dans la même fenêtre, cliquer sur "+" et ajouter un runtime iOS 17.x pour tester la version minimale.
3. (Terminal) Lister les simulateurs disponibles et noter : un grand iPhone (pour les captures), un petit iPhone (pour tester les petits écrans), un iPhone sous iOS 17.

**Commandes :**
```bash
xcodebuild -downloadPlatform iOS        # alternative en ligne de commande
xcrun simctl list runtimes
xcrun simctl list devices available
```

**Fichiers :** aucun.

**Concept :** un simulateur n'est pas un émulateur : il exécute l'app compilée pour le processeur du Mac. Il est rapide et fidèle pour l'interface, mais pas pour tout (notifications, calendrier, performances). On testera aussi sur un vrai iPhone.

**Terminé quand :** au moins un simulateur iOS récent et un simulateur iOS 17 démarrent depuis Xcode > Window > Devices and Simulators.

**Durée :** 30 min (téléchargements).

---

- [ ] **0.5 Configurer Git et l'outil GitHub**

**Objectif :** Git configuré avec la bonne identité et `gh` connecté à GitHub.

**Étapes :**
1. (Terminal) Vérifier Git, configurer nom et email.
2. Installer Homebrew s'il manque (https://brew.sh), puis `gh`.
3. Se connecter à GitHub avec `gh auth login` (choisir HTTPS et le navigateur).

**Commandes :**
```bash
git --version
git config --global user.name "Votre Nom"
git config --global user.email "votre@email"
git config --global init.defaultBranch main
brew install gh
gh auth login
gh auth status
```

**Fichiers :** `~/.gitconfig`.

**Concept :** rien de nouveau par rapport au web. Point spécifique iOS : certains fichiers générés par Xcode ne doivent jamais être versionnés (données utilisateur de Xcode, dossiers de build). On les exclut à la tâche suivante.

**Terminé quand :** `gh auth status` indique "Logged in".

**Durée :** 15 min

---

- [ ] **0.6 Créer le dépôt local et le dépôt GitHub**

**Objectif :** un dépôt privé `check-pap` sur GitHub contenant `suivi.md` et un `.gitignore` adapté à Xcode.

**Étapes :**
1. (Terminal) Initialiser Git dans le dossier du projet.
2. (En code) Créer `.gitignore` avec le contenu ci-dessous.
3. Premier commit, puis création du dépôt privé et envoi.

**Commandes :**
```bash
cd ~/Documents/Projets/CheckPap
git init
git add suivi.md .gitignore
git commit -m "chore: plan de suivi et gitignore"
gh repo create check-pap --private --source=. --push
```

Contenu de `.gitignore` :
```gitignore
# macOS
.DS_Store

# Xcode
xcuserdata/
*.xcuserstate
DerivedData/
build/
*.ipa
*.dSYM.zip
*.dSYM

# Swift Package Manager
.build/
.swiftpm/

# Captures et exports temporaires
/exports/
```

**Fichiers :** `.gitignore` (créé), `suivi.md` (versionné).

**Concept :** `xcuserdata` contient l'état de l'interface de Xcode propre à chaque personne (onglets ouverts, points d'arrêt). C'est comme `.vscode/` personnel : on ne le partage pas.

**Terminé quand :** le dépôt privé est visible sur GitHub avec les deux fichiers.

**Durée :** 15 min

---

- [ ] **0.7 Ajouter le compte développeur dans Xcode**

**Objectif :** que Xcode puisse signer l'app avec l'équipe du compte Apple Developer.

**Étapes :**
1. (À la main) Xcode > Settings > Accounts > "+" > Apple Account, se connecter.
2. Sélectionner le compte, vérifier que l'équipe (Team) apparaît avec le rôle "Admin" ou "Account Holder".
3. Cliquer sur "Manage Certificates..." et, si absent, créer un certificat "Apple Development".
4. Noter le Team ID (visible aussi sur https://developer.apple.com/account, rubrique Membership).

**Commandes :**
```bash
security find-identity -v -p codesigning   # liste les certificats de signature présents
```

**Fichiers :** aucun dans le projet (les certificats vont dans le Trousseau macOS).

**Concept :** iOS n'exécute que du code signé. La signature prouve qui a produit l'app. Il y a deux usages : "Development" (installer sur ses propres appareils) et "Distribution" (TestFlight et App Store). Xcode gère tout automatiquement si on coche "Automatically manage signing", ce qu'on fera.

**Terminé quand :** l'équipe apparaît dans Xcode > Settings > Accounts et un certificat Apple Development est listé.

**Durée :** 20 min

---

- [ ] **0.8 Vérifier la fiche App Store Connect**

**Objectif :** connaître l'identifiant de bundle (bundle ID) exact déjà associé à "Check Pap" et vérifier que rien ne bloque la publication.

**Étapes :**
1. (À la main) Ouvrir https://appstoreconnect.apple.com > Apps > Check Pap > App Information.
2. Noter : le Bundle ID, la langue principale, le SKU. **Le bundle ID d'une fiche existante ne peut plus être changé** : le projet Xcode devra utiliser exactement celui-ci.
3. Si la langue principale n'est pas le français, décider maintenant (voir Questions ouvertes) : elle se change dans App Information.
4. (À la main) Ouvrir https://developer.apple.com/account/resources/identifiers et vérifier que l'identifiant existe. Ne cocher aucune capacité pour l'instant.
5. (À la main) App Store Connect > Business (Accords, taxes et banque) : vérifier qu'aucun accord n'est en attente de signature. Pour une app gratuite, l'accord "Free Apps" suffit.
6. Recopier le bundle ID dans la section "Informations projet" ci-dessous.

**Commandes :** aucune.

**Fichiers :** `suivi.md` (compléter ci-dessous).

> **Informations projet (à compléter)**
> - Bundle ID : `...............`
> - Team ID : `...............`
> - SKU : `...............`
> - Langue principale App Store Connect : `...............`

**Concept :** le bundle ID (par exemple `com.exemple.checkpap`) est l'identité unique de l'app chez Apple, comme un nom de package npm, mais en notation de domaine inversé. Il relie le projet Xcode, la signature et la fiche App Store.

**Terminé quand :** le bundle ID, le Team ID et le SKU sont recopiés ici et aucun accord n'est en attente.

**Durée :** 20 min

---

- [ ] **0.9 Préparer un iPhone de test (recommandé)**

**Objectif :** pouvoir lancer l'app sur un vrai iPhone pour tester le calendrier et les notifications.

**Étapes :**
1. (À la main) Brancher l'iPhone au Mac, accepter "Faire confiance à cet ordinateur".
2. Sur l'iPhone : Réglages > Confidentialité et sécurité > Mode développeur > activer, redémarrer.
3. (À la main) Xcode > Window > Devices and Simulators : l'iPhone doit apparaître sans avertissement.

**Commandes :**
```bash
xcrun devicectl list devices
```

**Fichiers :** aucun.

**Concept :** l'appareil est enregistré automatiquement dans le compte développeur lors du premier lancement depuis Xcode. Le "Mode développeur" est une protection iOS : sans lui, aucune app non issue de l'App Store ou de TestFlight ne peut se lancer.

**Terminé quand :** l'iPhone apparaît comme "Connected" dans Devices and Simulators.

**Durée :** 20 min

---

## Phase 1 : création du projet dans Xcode

Objectif de la phase : un projet SwiftUI vide, signé, rangé, qui se lance sur simulateur et sur iPhone.

- [x] **1.1 Créer le projet**

**Objectif :** générer le projet Xcode avec les bonnes options dès le départ.

**Étapes (à la main dans Xcode) :**
1. File > New > Project > iOS > App > Next.
2. Remplir :
   - Product Name : `CheckPap` (sans espace ; le nom affiché "Check Pap" sera réglé en 1.2).
   - Team : l'équipe du compte développeur.
   - Organization Identifier : la partie avant `.CheckPap` du bundle ID noté en 0.8. Vérifier que le "Bundle Identifier" affiché en gris correspond **exactement** à celui d'App Store Connect (sinon on le corrigera en 1.2).
   - Interface : SwiftUI.
   - Language : Swift.
   - Testing System : Swift Testing (avec tests UI XCTest).
   - Storage : None. On ajoutera SwiftData à la main en 2.6 pour comprendre chaque ligne.
   - Ne pas cocher "Host in CloudKit".
3. Next, choisir le dossier `~/Documents/Projets/CheckPap`. **Décocher "Create Git repository on my Mac"** : le dépôt existe déjà.
4. Lancer une première fois avec Cmd+R sur un simulateur.

**Commandes (après création) :**
```bash
cd ~/Documents/Projets/CheckPap
git status
git add . && git commit -m "chore(1.1): création du projet Xcode"
```

**Fichiers créés :** `CheckPap.xcodeproj`, `CheckPap/CheckPapApp.swift`, `CheckPap/ContentView.swift`, `CheckPap/Assets.xcassets`, `CheckPapTests/`, `CheckPapUITests/`.

**Concept : l'anatomie d'une app SwiftUI.**
- `CheckPapApp.swift` porte l'annotation `@main` : c'est le point d'entrée, comme `main.tsx` qui appelle `createRoot(...).render(<App />)`.
- `App` déclare des `Scene`. `WindowGroup { ContentView() }` dit "affiche cette vue dans la fenêtre de l'app".
- `ContentView` est une `struct` conforme au protocole `View`. Sa propriété `body` renvoie l'interface, exactement comme un composant fonction React renvoie du JSX. Différence clé : une vue SwiftUI est une petite valeur peu coûteuse, recréée souvent ; on ne garde jamais d'état dans une variable ordinaire d'une vue (on verra `@State`).

**Terminé quand :** l'app "Hello, world!" s'affiche dans le simulateur et le commit est poussé.

**Durée :** 45 min

---

- [ ] **1.2 Régler la cible et la signature**

**Objectif :** cible iOS 17, iPhone, nom affiché "Check Pap", signature automatique.

**Étapes (à la main dans Xcode) :**
1. Cliquer sur le projet (icône bleue) > cible `CheckPap` > onglet **General** :
   - Supported Destinations : garder iPhone. Retirer Mac, Vision et iPad si présents (voir Questions ouvertes pour l'iPad).
   - Minimum Deployments : iOS 17.0.
   - Identity > Display Name : `Check Pap`.
   - Identity > Version : `0.1.0` ; Build : `1`.
   - Deployment Info : orientation Portrait seulement (simplifie la mise en page de la v1).
2. Onglet **Signing & Capabilities** :
   - Cocher "Automatically manage signing".
   - Team : votre équipe.
   - Bundle Identifier : exactement celui d'App Store Connect.
   - Aucune erreur rouge ne doit apparaître.
3. Faire de même pour les cibles `CheckPapTests` et `CheckPapUITests` (Team et iOS 17).
4. Lancer sur l'iPhone de test (sélectionner l'appareil en haut de Xcode, Cmd+R).

**Commandes :**
```bash
git commit -am "chore(1.2): cible iOS 17, nom affiché, signature"
```

**Fichiers modifiés :** `CheckPap.xcodeproj/project.pbxproj`.

**Concept :** "Version" est la version marketing visible par les utilisateurs (comme `version` dans `package.json`). "Build" est un compteur technique qui doit augmenter à chaque envoi à Apple, même si la version ne change pas.

**Terminé quand :** l'app se lance sur l'iPhone avec le nom "Check Pap" sous l'icône.

**Durée :** 30 min

---

- [x] **1.3 Mettre en place la structure des dossiers**

**Objectif :** une arborescence claire, organisée par fonctionnalité.

**Étapes :**
1. (À la main dans Xcode) Clic droit sur le dossier `CheckPap` > New Folder, créer l'arborescence ci-dessous. Les dossiers créés ainsi sont synchronisés avec le disque.
2. Déplacer `CheckPapApp.swift` dans `App/` et `ContentView.swift` dans `App/` (il deviendra `RootView`).
3. Déplacer `Assets.xcassets` dans `Resources/`.
4. Ajouter un fichier `README.md` vide dans chaque dossier vide si Git doit le suivre (Git ignore les dossiers vides).
5. Compiler (Cmd+B) pour vérifier que rien n'est cassé.

```
CheckPap/
├── App/                 # point d'entrée, vue racine, injection des dépendances
├── Models/
│   ├── Content/         # structures décodées depuis le JSON (lecture seule)
│   └── Persistence/     # modèles SwiftData (données de l'utilisateur)
├── Services/            # chargement du contenu, moteur de règles, calendrier, notifications, langue
├── Features/
│   ├── Onboarding/      # choix de la langue
│   ├── Procedure/       # accueil de la démarche
│   ├── Questionnaire/   # QCM
│   ├── Checklist/       # liste à cocher, fiches documents, prise de rendez-vous
│   ├── Reminders/       # rendez-vous, dates limites, calendrier, rappels
│   ├── Consulates/      # annuaire des consulats
│   ├── Legal/           # mentions, confidentialité, à propos
│   └── Settings/        # réglages (langue, rappels)
├── Shared/              # composants réutilisables (bandeau de mention, date de vérification...)
└── Resources/
    ├── Assets.xcassets
    ├── Content/         # fichiers JSON
    └── Localizable.xcstrings
CheckPapTests/
CheckPapUITests/
docs/                    # documentation hors app (schéma JSON, fiche App Store, politique de confidentialité)
scripts/                 # scripts de validation du contenu
```

**Commandes :**
```bash
mkdir -p docs scripts
git add . && git commit -m "chore(1.3): structure des dossiers"
```

**Fichiers :** déplacements uniquement.

**Concept :** en Swift, il n'y a pas d'`import` entre fichiers d'une même cible : tous les fichiers de la cible `CheckPap` se voient entre eux. Les dossiers servent seulement à ranger. C'est différent de React où chaque fichier importe explicitement ce qu'il utilise.

**Terminé quand :** l'arborescence existe, le projet compile, le commit est poussé.

**Durée :** 30 min

---

- [ ] **1.4 Découvrir l'éditeur : Preview, simulateur, débogueur**

**Objectif :** savoir itérer vite sur une vue et lire une erreur de compilation.

**Étapes :**
1. (En code) Dans `ContentView.swift`, modifier le texte, observer la mise à jour du canevas de prévisualisation (`#Preview`). Afficher le canevas avec Editor > Canvas (Option+Cmd+Entrée).
2. (En code) Introduire volontairement une erreur de type, lire le message dans le Issue Navigator (Cmd+5).
3. (À la main) Poser un point d'arrêt (clic dans la marge), lancer, inspecter une variable dans la console avec `po nomDeVariable`.
4. (À la main) Ouvrir le simulateur, tester Features > Toggle Appearance (mode sombre), et Settings > Accessibility > Larger Text.

**Commandes :** aucune.

**Fichiers :** `App/ContentView.swift` (modifications temporaires, à annuler).

**Concept :** `#Preview` est l'équivalent de Storybook intégré à l'éditeur : un rendu en direct d'une vue avec des données d'exemple. Swift est compilé et fortement typé : beaucoup d'erreurs qu'on verrait au runtime en JavaScript apparaissent ici avant même de lancer l'app.

**Terminé quand :** vous savez afficher une Preview, lire une erreur et utiliser un point d'arrêt.

**Durée :** 45 min

---

- [x] **1.5 Créer le String Catalog et activer les langues**

**Objectif :** préparer la traduction dès le début pour ne jamais écrire de texte "en dur non traduisible".

**Étapes :**
1. (À la main) Projet > onglet Info > Localizations : ajouter French et English. Vérifier que "Use Base Internationalization" est coché.
2. (À la main) Dans `Resources/`, File > New > File from Template > String Catalog, nommé `Localizable`.
3. (À la main) Ouvrir le catalogue, ajouter les langues avec le bouton "+".
4. Compiler : le texte "Hello, world!" doit apparaître automatiquement dans le catalogue.

**Commandes :**
```bash
git add . && git commit -m "chore(1.5): String Catalog fr/en"
```

**Fichiers créés :** `Resources/Localizable.xcstrings`.

**Concept :** un String Catalog est un fichier JSON géré par Xcode (comme un fichier `fr.json` de i18next) mais rempli automatiquement : à chaque compilation, Xcode trouve tous les `Text("...")` du code et les ajoute. On traduit ensuite dans un tableau. La langue de "développement" (la langue des textes écrits dans le code) est à décider (voir Questions ouvertes).

**Terminé quand :** le catalogue liste les deux langues et contient la chaîne du projet.

**Durée :** 1 h

---

## Phase 2 : modèle de données et fichiers JSON

Objectif de la phase : le contenu de la démarche vit dans des fichiers JSON, l'app sait les lire, les évaluer et enregistrer la progression de l'utilisateur.

Principe central : **deux types de données bien séparés**.
- Le **contenu** (démarches, questions, documents, liens, consulats) : en JSON, en lecture seule, remplaçable plus tard par un serveur.
- Les **données de l'utilisateur** (réponses, cases cochées, rendez-vous) : en SwiftData, sur le téléphone, qui ne référencent le contenu que par des identifiants.

- [ ] **2.0 Inventaire des sources officielles**

**Objectif :** savoir, source par source, quelles démarches existent au niveau national, ce que chacune exige, et ce qui change d'une préfecture à l'autre, avant d'écrire une seule ligne de contenu.

**Étapes :**
1. (Recherche) Établir le socle national à partir de l'ANEF, de service-public.fr et de Légifrance (CESEDA, Code civil pour la nationalité).
   Puis comparer plusieurs préfectures (Val-de-Marne, Paris, Rhône, Bouches-du-Rhône...) pour lister ce qui varie localement.
   Enfin, identifier la source officielle de l'annuaire des préfectures et sous-préfectures.
2. Pour chaque démarche : canal (ANEF en ligne, rendez-vous, courrier), conditions citées mot pour mot, liste des pièces, délais, coût, URL et date de consultation.
3. (À la main) Relire l'inventaire, cliquer sur chaque lien, signaler ce qui est faux ou manquant.
4. Choisir les démarches de la v1 à partir de cet inventaire.

**Commandes :** aucune.

**Fichiers créés :** `docs/sources/inventaire-demarches.md`.

**Concept :** l'app ne sera jamais plus fiable que ses sources. Une condition sans URL n'entre pas dans le JSON. C'est la même discipline qu'une API dont chaque champ est documenté.

**Terminé quand :** l'inventaire est relu et la liste des démarches de la v1 est décidée.

**Durée :** 2 h de relecture (la collecte est faite par recherche automatisée).

---

- [ ] **2.1 Concevoir le schéma JSON**

**Objectif :** écrire le format des fichiers de contenu avant tout code.

**Étapes (en documentation, pas de Swift) :**
1. Créer `docs/content-schema.md` décrivant :
   - `catalog.json` : `schemaVersion`, `contentVersion`, liste des démarches disponibles.
   - `procedures/<id>.json` (un fichier par démarche, socle national) : identifiant, titre, description, `lastVerified`, sources, questions, documents, échéances.
   - `prefectures/index.json` : liste de toutes les préfectures et sous-préfectures (code département, nom, site, coordonnées, codes postaux ou communes couverts), générée depuis l'annuaire officiel.
   - `prefectures/<code-departement>.json` (seulement pour les préfectures vérifiées) : prise de rendez-vous, sous-préfecture compétente selon la commune, pièces ou conditions locales qui s'ajoutent au socle, `lastVerified`, sources.
   - Règle de fusion : liste finale = socle national + ajouts locaux. Une précision locale peut ajouter ou préciser une pièce, jamais en retirer une sans source.
   - `consulates.json` : pays, ville, adresse, téléphone, site, `lastVerified`.
2. Définir un type "texte traduit" commun : un objet `{ "fr": "...", "en": "..." }`. Ajouter une langue = ajouter une clé, sans toucher au code.
3. Définir le format des conditions, purement déclaratif, par exemple :
   ```json
   { "all": [ { "question": "has_work_contract", "equals": "yes" },
              { "not": { "question": "nationality_group", "in": ["eu"] } } ] }
   ```
   Opérateurs prévus : `equals`, `in`, `all`, `any`, `not`. Une question ou un document sans condition est toujours affiché.
4. Définir les échéances relatives, par exemple `{ "id": "file_before_expiry", "relativeTo": "permit_expiry_date", "offsetDays": -60, "title": {...} }`. Les valeurs (ici -60) sont du contenu provisoire, pas du code.

**Commandes :** aucune.

**Fichiers créés :** `docs/content-schema.md`.

**Concept :** c'est un moteur piloté par les données, comme un formulaire dynamique généré depuis un schéma JSON en React. Le code sait **évaluer** des conditions ; il ne sait pas **quelles** conditions existent. Changer une règle administrative = modifier un JSON, jamais recompiler.

**Terminé quand :** le schéma couvre questions, documents, conditions, liens, échéances, consulats et dates de vérification, et peut accueillir une 3e langue sans modification.

**Durée :** 1 h 30

---

- [ ] **2.2 Écrire les fichiers JSON provisoires**

**Objectif :** un jeu de contenu réaliste mais marqué comme provisoire, pour développer l'interface.

**Étapes :**
1. (En code) Créer les fichiers dans `Resources/Content/`.
2. Marquer chaque texte provisoire avec le préfixe `[PROVISOIRE]` pour qu'il soit impossible de l'oublier avant publication.
3. Prévoir 5 à 8 questions, 10 à 15 documents dont certains conditionnels, 3 à 5 consulats.
4. (À la main) Dans l'inspecteur de fichier (panneau de droite), vérifier que chaque JSON a la case "Target Membership > CheckPap" cochée, sinon il ne sera pas inclus dans l'app.
5. Valider la syntaxe.

**Commandes :**
```bash
for f in CheckPap/Resources/Content/**/*.json CheckPap/Resources/Content/*.json; do
  python3 -m json.tool "$f" > /dev/null && echo "OK $f" || echo "ERREUR $f"
done
```

**Fichiers créés :** `Resources/Content/catalog.json`, `Resources/Content/procedures/*.json`, `Resources/Content/prefectures/index.json`, `Resources/Content/prefectures/94.json` (premier exemple local), `Resources/Content/consulates.json`.

**Concept :** les fichiers ajoutés à la cible sont copiés dans le "bundle" de l'app, l'équivalent du dossier `public/` d'un projet web : accessibles en lecture à l'exécution.

**Terminé quand :** les trois fichiers sont valides, inclus dans la cible et contiennent au moins un document conditionnel et une échéance.

**Durée :** 1 h 30

---

- [ ] **2.3 Créer les structures Swift décodables**

**Objectif :** transformer le JSON en types Swift sûrs.

**Étapes (en code) :**
1. Dans `Models/Content/`, créer `LocalizedText`, `Catalog`, `Procedure`, `Question`, `AnswerOption`, `RequiredDocument`, `ExternalLink`, `Deadline`, `Consulate`.
2. Créer `Condition` comme un `enum` récursif (voir concept).
3. Rendre tout `Decodable`, `Identifiable` (champ `id`) et `Hashable`.
4. Ajouter à `LocalizedText` une méthode `resolved(for languageCode:)` avec repli sur le français si la traduction manque.
5. Écrire une Preview ou un petit test qui décode un fichier de démarche et le fichier local `prefectures/94.json`.

**Commandes :** aucune.

**Fichiers créés :** `Models/Content/*.swift` (un fichier par type), `Models/Content/Condition.swift`.

**Concept :**
- `struct` : un type valeur, copié à chaque affectation, comme un objet immuable. En Swift on préfère les `struct` aux `class` par défaut.
- `Decodable` : le compilateur génère le code de lecture du JSON. C'est l'équivalent d'une `interface` TypeScript **plus** un validateur type Zod en une seule déclaration : si le JSON ne correspond pas, le décodage échoue avec une erreur précise.
- Optionnel `String?` : la valeur peut être absente, comme `string | undefined`, mais le compilateur oblige à traiter le cas.
- `enum` avec valeurs associées : `case equals(question: String, value: String)`, `case all([Condition])`. C'est une union discriminée TypeScript, avec en plus un `switch` que le compilateur vérifie exhaustif.

**Terminé quand :** le fichier de démarche se décode sans erreur et une valeur erronée dans le JSON produit une erreur lisible.

**Durée :** 2 h

---

- [ ] **2.4 Créer le dépôt de contenu (ContentRepository)**

**Objectif :** une seule porte d'entrée pour lire le contenu, remplaçable plus tard par une version serveur.

**Étapes (en code) :**
1. Dans `Services/`, déclarer un protocole `ContentRepository` avec `func loadCatalog() async throws -> Catalog`, `func loadProcedure(id:) async throws -> Procedure`, `func loadConsulates() async throws -> [Consulate]`.
2. Implémenter `BundleContentRepository` qui lit les fichiers avec `Bundle.main.url(forResource:withExtension:subdirectory:)` et `JSONDecoder`.
3. Configurer le décodeur pour les dates au format ISO 8601 (`decoder.dateDecodingStrategy = .iso8601`).
4. Définir un `enum ContentError: Error` (fichier manquant, décodage impossible) avec des messages clairs.

**Commandes :** aucune.

**Fichiers créés :** `Services/ContentRepository.swift`, `Services/BundleContentRepository.swift`.

**Concept :**
- `protocol` : un contrat, comme une `interface` TypeScript qu'une classe `implements`. Le reste de l'app ne connaît que le protocole ; plus tard, un `RemoteContentRepository` le remplacera sans rien changer ailleurs.
- `async throws` : la fonction est asynchrone et peut échouer. On l'appelle avec `try await`, exactement comme `await` dans un `try/catch` en JavaScript. Le compilateur refuse d'appeler une fonction `throws` sans `try`.

**Terminé quand :** un appel `try await BundleContentRepository().loadProcedure(id:)` renvoie la démarche complète.

**Durée :** 1 h 30

---

- [ ] **2.5 Écrire le moteur de règles**

**Objectif :** à partir des réponses, calculer les questions visibles et la liste des documents, sans aucune règle métier dans le code.

**Étapes (en code) :**
1. Dans `Services/`, créer `RulesEngine` avec deux fonctions pures :
   - `visibleQuestions(in procedure:, answers:) -> [Question]`
   - `requiredDocuments(in procedure:, answers:) -> [RequiredDocument]`
2. Implémenter `evaluate(_ condition:, answers:) -> Bool` avec un `switch` sur l'`enum Condition`.
3. Les réponses sont un `[String: String]` (identifiant de question vers identifiant de réponse ou date ISO).
4. Une condition qui porte sur une question sans réponse est évaluée à `false` (règle générique, documentée dans `docs/content-schema.md`).

**Commandes :** aucune.

**Fichiers créés :** `Services/RulesEngine.swift`.

**Concept :** fonction pure = même entrée, même sortie, aucun effet de bord. C'est la partie la plus facile à tester (tests en 9.2). Le `switch` sur un `enum` sans `default` garantit qu'un nouvel opérateur ajouté plus tard fera échouer la compilation tant qu'on ne l'a pas géré : un filet de sécurité que TypeScript n'offre qu'avec des astuces (`never`).

**Terminé quand :** dans une Preview ou un test, deux jeux de réponses différents donnent deux listes de documents différentes.

**Durée :** 1 h 30

---

- [ ] **2.6 Créer les modèles SwiftData**

**Objectif :** enregistrer sur le téléphone les réponses et l'état des cases cochées.

**Étapes (en code) :**
1. Dans `Models/Persistence/`, créer :
   - `ChecklistSession` : `procedureId`, `contentVersion`, `answers` (dictionnaire encodé), `createdAt`, `updatedAt`, relation vers les éléments.
   - `ChecklistItemState` : `documentId`, `isChecked`, `checkedAt`.
   - `Reminder` (servira en phase 6) : `kind` (rendez-vous ou échéance), `title`, `date`, `notificationId`.
2. Annoter chaque classe avec `@Model`.
3. Dans `CheckPapApp.swift`, ajouter `.modelContainer(for: [ChecklistSession.self, Reminder.self])` sur la `WindowGroup`.
4. Ne stocker **que des identifiants** de contenu, jamais les textes (ils changeront avec les mises à jour du JSON).

**Commandes :** aucune.

**Fichiers créés :** `Models/Persistence/ChecklistSession.swift`, `Models/Persistence/ChecklistItemState.swift`, `Models/Persistence/Reminder.swift`. **Modifié :** `App/CheckPapApp.swift`.

**Concept :**
- SwiftData est une base locale (SQLite en dessous) pilotée par des classes Swift, comme un ORM type Eloquent mais sans écrire de migration pour les changements simples.
- `@Model` est une macro : elle génère le code de persistance, comme un décorateur.
- Ici on utilise des `class` et non des `struct` : un objet en base a une identité et peut être modifié en place, partagé entre plusieurs vues.
- `.modelContainer(...)` crée la base et la rend disponible à toutes les vues, comme un `<QueryClientProvider>` en haut de l'arbre React.

**Terminé quand :** l'app se lance sans erreur avec le conteneur SwiftData configuré.

**Durée :** 1 h 30

---

- [ ] **2.7 Créer le magasin de contenu observable et l'injecter**

**Objectif :** charger le contenu une fois au démarrage et le rendre disponible à toutes les vues.

**Étapes (en code) :**
1. Dans `Services/`, créer `ContentStore`, une classe annotée `@Observable`, avec un état `loading / loaded(Procedure) / failed(Error)` et une méthode `load()`.
2. Dans `CheckPapApp`, créer le store avec `@State private var contentStore = ContentStore(repository: BundleContentRepository())` et l'injecter avec `.environment(contentStore)`.
3. Dans `RootView`, lire le store avec `@Environment(ContentStore.self)` et lancer `load()` dans `.task { }`.
4. Afficher un `ProgressView` pendant le chargement et un message d'erreur si échec.

**Commandes :** aucune.

**Fichiers créés :** `Services/ContentStore.swift`. **Modifiés :** `App/CheckPapApp.swift`, `App/RootView.swift` (renommage de `ContentView`).

**Concept :**
- `@Observable` : SwiftUI suit automatiquement quelles propriétés une vue lit, et ne redessine que ces vues quand elles changent. C'est proche d'un store MobX ou Pinia, sans `useSelector` à écrire.
- `.environment(...)` / `@Environment(...)` : c'est `Context.Provider` / `useContext` en React.
- `.task { }` : s'exécute quand la vue apparaît et s'annule quand elle disparaît, comme un `useEffect(() => {...}, [])` avec nettoyage automatique.
- `@State` : un état possédé par la vue, comme `useState`.

**Terminé quand :** au lancement, l'app affiche brièvement un chargement puis le titre de la démarche lu depuis le JSON.

**Durée :** 1 h

---

## Phase 3 : écran de choix de la langue

Objectif de la phase : au premier lancement, l'utilisateur choisit sa langue puis son département ; il peut la changer plus tard dans l'app ; l'interface est prête pour l'arabe.

- [ ] **3.1 Créer le gestionnaire de langue**

**Objectif :** une source unique de vérité pour la langue de l'app, interface et contenu JSON compris.

**Étapes (en code) :**
1. Dans `Services/`, créer `enum AppLanguage: String, CaseIterable` avec `fr`, `en` (et `ar` commenté, prévu), une propriété `nativeName` ("Français", "English") et `isRightToLeft`.
2. Créer `LanguageSettings` (`@Observable`) qui lit et écrit la langue choisie dans `UserDefaults`, avec par défaut la langue du téléphone si elle est supportée, sinon le français.
3. Dans `CheckPapApp`, appliquer à la racine :
   - `.environment(\.locale, Locale(identifier: language.rawValue))`
   - `.environment(\.layoutDirection, language.isRightToLeft ? .rightToLeft : .leftToRight)`
4. Utiliser la même langue pour `LocalizedText.resolved(for:)`.

**Commandes :** aucune.

**Fichiers créés :** `Services/AppLanguage.swift`, `Services/LanguageSettings.swift`. **Modifié :** `App/CheckPapApp.swift`.

**Concept :**
- `UserDefaults` : petit stockage clé/valeur persistant, l'équivalent de `localStorage`. SwiftUI propose `@AppStorage("cle")`, qui est littéralement un `useLocalStorage` : la vue se met à jour quand la valeur change.
- La `locale` dans l'environnement fait que tous les `Text("...")` en dessous se traduisent dans cette langue, sans redémarrer l'app.
- `layoutDirection` inverse automatiquement l'alignement "leading/trailing" pour l'arabe.

**Terminé quand :** changer la valeur à la main dans le code fait basculer textes et contenu JSON entre français et anglais.

**Durée :** 1 h 30

---

- [ ] **3.2 Écran de choix au premier lancement**

**Objectif :** au tout premier lancement, afficher le choix de langue avant toute autre chose.

**Étapes (en code) :**
1. Dans `Features/Onboarding/`, créer `LanguagePickerView` : une liste des langues affichées dans leur propre langue, un bouton "Continuer".
2. Stocker un indicateur `hasChosenLanguage` avec `@AppStorage`.
3. Dans `RootView`, afficher `LanguagePickerView` si l'indicateur est faux, sinon l'accueil de la démarche.
4. Ajouter le bandeau "service indépendant" en bas de cet écran (le composant sera créé en 8.1 ; mettre un texte temporaire).
5. Ajouter une `#Preview` en français et une en anglais.

**Commandes :** aucune.

**Fichiers créés :** `Features/Onboarding/LanguagePickerView.swift`. **Modifié :** `App/RootView.swift`.

**Concept :** en SwiftUI, un `if` dans `body` affiche une vue ou une autre, comme un rendu conditionnel `{cond ? <A/> : <B/>}` en JSX. `List`, `ForEach` et `Button` remplacent `<ul>`, `.map()` et `<button>`. `ForEach` a besoin d'éléments `Identifiable`, comme la prop `key` en React.

**Terminé quand :** après suppression de l'app du simulateur, le premier lancement affiche le choix de langue, et le second lancement va directement à l'accueil.

**Durée :** 1 h 30

---

- [ ] **3.3 Changer la langue depuis les réglages**

**Objectif :** permettre de changer de langue dans l'app, et proposer aussi le réglage iOS.

**Étapes (en code) :**
1. Dans `Features/Settings/`, créer `SettingsView` avec un `Form` contenant un `Picker` de langue.
2. Ajouter un bouton "Ouvrir les réglages iOS" qui ouvre `UIApplication.openSettingsURLString` (iOS y affiche le choix de langue par app car l'app déclare plusieurs langues).
3. Ajouter l'accès aux réglages depuis l'accueil (icône engrenage dans la barre de navigation).

**Commandes :** aucune.

**Fichiers créés :** `Features/Settings/SettingsView.swift`.

**Concept :** `Picker(selection: $langue)` : le `$` crée un `Binding`, c'est-à-dire une lecture **et** une écriture vers un état. C'est l'équivalent d'un champ contrôlé React (`value` + `onChange`) en un seul symbole, ou de `v-model` en Vue.

**Terminé quand :** changer la langue dans les réglages met à jour immédiatement toute l'interface et le contenu.

**Durée :** 1 h

---

- [ ] **3.4 Vérifier la compatibilité droite à gauche**

**Objectif :** garantir que l'ajout de l'arabe plus tard ne cassera pas la mise en page.

**Étapes :**
1. (À la main) Product > Scheme > Edit Scheme > Run > Options > App Language : "Right-to-Left Pseudolanguage". Lancer.
2. Vérifier chaque écran existant : alignements, icônes de flèche, ordre des éléments.
3. (En code) Remplacer tout `.left`/`.right` par `.leading`/`.trailing`. Utiliser des SF Symbols directionnels (`chevron.forward` plutôt que `chevron.right`).
4. Remettre "System Language" dans le schéma.

**Commandes :** aucune.

**Fichiers :** corrections éventuelles dans les vues.

**Concept :** "leading" = début de ligne dans le sens de lecture, "trailing" = fin. C'est l'équivalent de `margin-inline-start` en CSS logique. SwiftUI inverse aussi automatiquement les `HStack` en mode droite à gauche.

**Terminé quand :** en pseudo-langue droite à gauche, tous les écrans existants sont correctement miroités.

**Durée :** 30 min (à refaire à la fin de chaque phase d'interface).

---

- [ ] **3.5 Choix du département**

**Objectif :** associer l'utilisateur à sa préfecture, n'importe où en France.

**Étapes (en code) :**
1. Dans `Features/Onboarding/`, créer `DepartmentPickerView` : recherche par numéro, nom de département ou code postal (`.searchable`), liste issue de `prefectures/index.json`.
2. Enregistrer le département choisi (`@AppStorage`), modifiable dans les réglages.
3. Si la commune relève d'une sous-préfecture, le proposer d'après l'annuaire.
4. Afficher pour la préfecture choisie : "Précisions locales vérifiées le ..." ou "Précisions locales pas encore vérifiées : consultez le site de la préfecture" avec le lien.
5. Aucune localisation GPS : saisie manuelle uniquement (pas de permission à demander, rien ne sort du téléphone).

**Commandes :** aucune.

**Fichiers créés :** `Features/Onboarding/DepartmentPickerView.swift`.

**Concept :** filtrer une liste pendant la saisie avec une propriété calculée, comme un `filter` sur un état `query` en React. Le résultat de la sélection est une simple chaîne ("94") stockée comme dans `localStorage`.

**Terminé quand :** on peut choisir n'importe quel département de métropole et d'outre-mer, et l'état de vérification locale s'affiche.

**Durée :** 1 h 30

---

## Phase 4 : QCM

Objectif de la phase : l'utilisateur répond aux questions de la démarche, une par une, avec retour arrière possible.

- [ ] **4.0 Écran de choix de la démarche**

**Objectif :** l'utilisateur choisit sa situation (changement de statut, renouvellement, naturalisation...) avant le QCM.

**Étapes (en code) :**
1. Dans `Features/Procedure/`, créer `ProcedurePickerView` : une carte en verre par démarche listée dans `catalog.json` (icône, titre, une phrase d'explication).
2. Une option "Je ne sais pas" qui mène à quelques questions d'orientation, elles aussi définies dans le JSON.
3. Le choix pousse l'écran d'accueil de la démarche (4.1).

**Commandes :** aucune.

**Fichiers créés :** `Features/Procedure/ProcedurePickerView.swift`.

**Concept :** la liste vient du JSON, pas du code. Ajouter une démarche = ajouter une entrée dans `catalog.json` et son fichier, sans recompiler une seule vue. C'est un rendu de liste piloté par les données, comme un `items.map(...)` en React.

**Terminé quand :** toutes les démarches du catalogue s'affichent et chacune ouvre son propre questionnaire.

**Durée :** 1 h 30

---

- [ ] **4.1 Écran d'accueil de la démarche**

**Objectif :** présenter la démarche avant de commencer le questionnaire.

**Étapes (en code) :**
1. Dans `Features/Procedure/`, créer `ProcedureHomeView` : titre, description, préfecture, date de dernière vérification, sources, bouton "Commencer".
2. Envelopper l'app dans un `NavigationStack` (dans `RootView`).
3. Le bouton "Commencer" pousse l'écran du questionnaire.
4. S'il existe déjà une session en base, afficher "Reprendre ma liste" à la place (requête SwiftData, voir 4.6).

**Commandes :** aucune.

**Fichiers créés :** `Features/Procedure/ProcedureHomeView.swift`. **Modifié :** `App/RootView.swift`.

**Concept :** `NavigationStack` gère une pile d'écrans avec le bouton retour natif, comme un routeur (React Router) mais en mode pile. `NavigationLink(value:)` + `.navigationDestination(for:)` correspond à une route typée.

**Terminé quand :** l'accueil affiche les informations du JSON et le bouton ouvre un écran vide de questionnaire.

**Durée :** 1 h 30

---

- [ ] **4.2 Logique du questionnaire (ViewModel)**

**Objectif :** isoler la logique de navigation entre questions de l'affichage.

**Étapes (en code) :**
1. Dans `Features/Questionnaire/`, créer `QuestionnaireModel` (`@Observable`) : réponses, index courant, `currentQuestion`, `canGoNext`, `next()`, `back()`, `isFinished`.
2. Les questions affichées viennent de `RulesEngine.visibleQuestions(...)`, recalculées après chaque réponse (une réponse peut faire apparaître ou disparaître une question suivante).
3. Si une réponse change et rend une question invisible, supprimer sa réponse.

**Commandes :** aucune.

**Fichiers créés :** `Features/Questionnaire/QuestionnaireModel.swift`.

**Concept :** séparer logique et vue, comme un hook personnalisé `useQuestionnaire()` en React. La vue se contente de lire les propriétés et d'appeler des méthodes ; la logique est testable sans interface.

**Terminé quand :** dans une Preview, on peut parcourir les questions avec des boutons temporaires et voir une question conditionnelle apparaître.

**Durée :** 1 h 30

---

- [ ] **4.3 Vue d'une question**

**Objectif :** afficher chaque type de question défini dans le JSON.

**Étapes (en code) :**
1. Créer `QuestionView` qui choisit l'affichage selon le type : choix unique (liste de boutons), oui/non, date (`DatePicker`).
2. Chaque option affiche son texte traduit et éventuellement une aide (texte secondaire).
3. Mettre en évidence l'option choisie (coche + style).
4. Bouton "Suivant" désactivé tant qu'aucune réponse n'est donnée.

**Commandes :** aucune.

**Fichiers créés :** `Features/Questionnaire/QuestionView.swift`, `Features/Questionnaire/ChoiceRow.swift`.

**Concept :** composition de vues. Chaque petite vue (`ChoiceRow`) reçoit ses données en paramètres comme des props, et un `Binding` quand elle doit modifier une valeur du parent. Les "modifiers" (`.padding()`, `.font(.headline)`) s'enchaînent comme des classes Tailwind, mais l'ordre compte : `.padding().background()` n'est pas `.background().padding()`.

**Terminé quand :** les trois types de questions s'affichent et enregistrent correctement la réponse.

**Durée :** 2 h

---

- [ ] **4.4 Progression, retour arrière et accessibilité**

**Objectif :** un questionnaire confortable pour tous, y compris avec VoiceOver et un grand texte.

**Étapes (en code) :**
1. Ajouter une barre de progression (`ProgressView(value:total:)`) et "Question 3 sur 7".
2. Le bouton retour de la navigation ou un bouton "Précédent" ramène à la question d'avant avec la réponse conservée.
3. Ajouter `.accessibilityLabel` et `.accessibilityHint` là où l'icône seule ne suffit pas.
4. (À la main) Tester avec la taille de texte maximale (Accessibility Inspector : Xcode > Open Developer Tool > Accessibility Inspector).

**Commandes :** aucune.

**Fichiers modifiés :** `Features/Questionnaire/*.swift`.

**Concept :** Dynamic Type : iOS agrandit les polices selon le réglage de l'utilisateur. En utilisant les styles sémantiques (`.font(.body)`) plutôt que des tailles fixes, tout s'adapte, comme utiliser des `rem` en CSS.

**Terminé quand :** le questionnaire est utilisable avec VoiceOver et en taille de texte maximale, sans texte coupé.

**Durée :** 1 h 30

---

- [ ] **4.5 Récapitulatif et création de la liste**

**Objectif :** montrer les réponses avant de générer la liste, puis l'enregistrer.

**Étapes (en code) :**
1. Créer `AnswersSummaryView` : liste des questions et réponses, chacune modifiable (retour à la question).
2. Bouton "Voir ma liste de documents" :
   - calcule les documents avec `RulesEngine.requiredDocuments(...)`,
   - crée une `ChecklistSession` et ses `ChecklistItemState` (tous non cochés),
   - les insère avec `modelContext.insert(...)`,
   - navigue vers la liste.
3. Afficher sous le bouton : "Cette liste est une aide. Elle ne remplace pas les informations de la préfecture."

**Commandes :** aucune.

**Fichiers créés :** `Features/Questionnaire/AnswersSummaryView.swift`.

**Concept :** `@Environment(\.modelContext)` donne accès à la base, comme une instance d'ORM. SwiftData enregistre automatiquement les changements (sauvegarde automatique), un peu comme un état persistant.

**Terminé quand :** valider le récapitulatif crée une session visible après redémarrage de l'app.

**Durée :** 1 h

---

- [ ] **4.6 Reprendre ou recommencer**

**Objectif :** retrouver sa liste au relancement, ou repartir de zéro volontairement.

**Étapes (en code) :**
1. Dans `ProcedureHomeView`, lire la session existante avec `@Query`.
2. Si une session existe, proposer "Reprendre ma liste" et "Recommencer le questionnaire".
3. "Recommencer" demande confirmation (`.confirmationDialog`), puis supprime la session et ses éléments.

**Commandes :** aucune.

**Fichiers modifiés :** `Features/Procedure/ProcedureHomeView.swift`.

**Concept :** `@Query` lit la base et met la vue à jour automatiquement à chaque changement, comme `useQuery` de TanStack Query, mais sur une base locale. Une suppression en cascade se déclare sur la relation (`@Relationship(deleteRule: .cascade)`).

**Terminé quand :** fermer et rouvrir l'app ramène à la liste ; "Recommencer" efface tout après confirmation.

**Durée :** 1 h

---

## Phase 5 : liste à cocher

Objectif de la phase : une liste claire des documents, cochable, avec explications, liens, prise de rendez-vous et annuaire des consulats.

- [ ] **5.1 Liste cochable**

**Objectif :** afficher les documents de la session et permettre de les cocher.

**Étapes (en code) :**
1. Dans `Features/Checklist/`, créer `ChecklistView` qui reçoit la session et fait la jointure entre les `ChecklistItemState` (en base) et les `RequiredDocument` (dans le JSON) par `documentId`.
2. Chaque ligne : case à cocher, nom du document, courte précision.
3. Taper la case modifie `isChecked` et `checkedAt`.
4. Ajouter un retour haptique léger (`.sensoryFeedback`).

**Commandes :** aucune.

**Fichiers créés :** `Features/Checklist/ChecklistView.swift`, `Features/Checklist/ChecklistRow.swift`.

**Concept :** `@Bindable` permet de créer des `Binding` (`$item.isChecked`) vers les propriétés d'un objet `@Observable` ou `@Model`. Un `Toggle(isOn: $item.isChecked)` modifie directement la base, sans gestionnaire d'événement à écrire.

**Terminé quand :** cocher un document survit à la fermeture de l'app.

**Durée :** 1 h 30

---

- [ ] **5.2 Fiche détaillée d'un document**

**Objectif :** expliquer chaque document avec ses liens et sa date de vérification.

**Étapes (en code) :**
1. Créer `DocumentDetailView` : explication, précisions (original, copie, traduction...), liens externes, date de dernière vérification, rappel "service indépendant".
2. Les liens s'ouvrent dans Safari avec `Link(destination:)`.
3. La fiche passeport renvoie vers l'annuaire des consulats (5.5).

**Commandes :** aucune.

**Fichiers créés :** `Features/Checklist/DocumentDetailView.swift`.

**Concept :** `Link` ouvre une URL dans le navigateur du système, comme `<a target="_blank">`. Les `URL` en Swift sont un type à part : une chaîne invalide donne `nil`, qu'il faut gérer (optionnel).

**Terminé quand :** chaque document ouvre sa fiche, les liens fonctionnent et la date de vérification est visible.

**Durée :** 1 h 30

---

- [ ] **5.3 Progression et regroupement**

**Objectif :** montrer l'avancement et ranger les documents par catégorie.

**Étapes (en code) :**
1. En-tête : "5 documents prêts sur 12" et une jauge.
2. Regrouper par catégorie définie dans le JSON (identité, études, ressources, logement...) avec `Section`.
3. Option "Masquer les documents prêts".

**Commandes :** aucune.

**Fichiers modifiés :** `Features/Checklist/ChecklistView.swift`.

**Concept :** propriétés calculées (`var progress: Double { ... }`) : recalculées à chaque lecture, comme une valeur dérivée dans le rendu React ou un `computed` en Vue. Pas besoin de `useMemo` pour des calculs légers.

**Terminé quand :** la jauge et les sections reflètent l'état réel de la liste.

**Durée :** 1 h

---

- [ ] **5.4 Explication de la prise de rendez-vous**

**Objectif :** expliquer comment prendre rendez-vous, sans automatiser ni promettre quoi que ce soit.

**Étapes (en code) :**
1. Créer `AppointmentGuideView` alimentée par la section "rendez-vous" du JSON : étapes numérotées, lien vers la page de la préfecture, conseils pratiques.
2. Bouton "J'ai obtenu un rendez-vous" qui mène à la saisie de date (phase 6).
3. Accès depuis un bouton en haut de la liste.

**Commandes :** aucune.

**Fichiers créés :** `Features/Checklist/AppointmentGuideView.swift`.

**Concept :** réutiliser les mêmes composants (texte traduit, lien, date de vérification) : en SwiftUI comme en React, on construit des petites vues réutilisables dans `Shared/`.

**Terminé quand :** l'écran affiche les étapes du JSON et le lien ouvre la bonne page.

**Durée :** 1 h

---

- [ ] **5.5 Annuaire des consulats**

**Objectif :** liste consultable des consulats, avec coordonnées et liens uniquement.

**Étapes (en code) :**
1. Dans `Features/Consulates/`, créer `ConsulateListView` avec recherche (`.searchable`) par pays ou ville.
2. Créer `ConsulateDetailView` : adresse, téléphone (lien `tel:`), site web, date de vérification. Aucune procédure.
3. Rendre l'annuaire accessible depuis la fiche passeport et depuis l'accueil.

**Commandes :** aucune.

**Fichiers créés :** `Features/Consulates/ConsulateListView.swift`, `Features/Consulates/ConsulateDetailView.swift`.

**Concept :** `.searchable(text: $query)` ajoute une barre de recherche native ; on filtre avec une propriété calculée (`consulates.filter { ... }`), comme un `filter` dans le rendu React.

**Terminé quand :** la recherche filtre la liste et le téléphone se compose depuis un iPhone réel.

**Durée :** 1 h 30

---

- [ ] **5.6 Gérer une mise à jour du contenu**

**Objectif :** si le JSON change (nouvelle version), mettre à jour la liste sans perdre les cases cochées.

**Étapes (en code) :**
1. Au chargement, comparer `session.contentVersion` avec `catalog.contentVersion`.
2. Si différent : recalculer les documents avec les réponses enregistrées, conserver l'état coché des `documentId` encore présents, ajouter les nouveaux, retirer les disparus.
3. Afficher un bandeau "Votre liste a été mise à jour le ..." que l'on peut fermer.

**Commandes :** aucune.

**Fichiers créés :** `Services/ChecklistSync.swift`.

**Concept :** c'est une réconciliation par clé, comme le diff de React sur les `key` d'une liste. Elle sera indispensable quand le contenu viendra d'un serveur.

**Terminé quand :** modifier `contentVersion` et un document dans le JSON met la liste à jour en conservant les autres cases cochées.

**Durée :** 1 h 30

---

## Phase 6 : calendrier et notifications

Objectif de la phase : l'utilisateur ajoute son rendez-vous et ses dates limites à son calendrier et reçoit des rappels, sans donner accès à son calendrier.

- [ ] **6.1 Saisir un rendez-vous ou une date personnelle**

**Objectif :** enregistrer la date du rendez-vous et la date d'expiration du titre actuel.

**Étapes (en code) :**
1. Dans `Features/Reminders/`, créer `ReminderFormView` : type (rendez-vous, expiration du titre), date et heure, lieu (prérempli depuis le JSON pour la préfecture).
2. Enregistrer un `Reminder` en SwiftData.
3. Créer `RemindersListView` accessible depuis la liste.

**Commandes :** aucune.

**Fichiers créés :** `Features/Reminders/ReminderFormView.swift`, `Features/Reminders/RemindersListView.swift`.

**Concept :** `Form` + `DatePicker` donne un formulaire natif complet. Les dates sont des `Date` (un instant absolu) ; l'affichage dans le bon fuseau et la bonne langue est fait par le formateur, jamais à la main.

**Terminé quand :** un rendez-vous saisi apparaît dans la liste après redémarrage.

**Durée :** 1 h 30

---

- [ ] **6.2 Calculer les échéances depuis le JSON**

**Objectif :** générer des dates limites suggérées à partir d'une date saisie, selon les règles du JSON.

**Étapes (en code) :**
1. Dans `Services/`, créer `DeadlineCalculator` : pour chaque `Deadline` du JSON, `date = dateDeReference + offsetDays` avec `Calendar.current.date(byAdding:)`.
2. Afficher ces échéances comme "suggestions" avec la mention "à vérifier auprès de la préfecture".
3. L'utilisateur choisit lesquelles ajouter en rappel.

**Commandes :** aucune.

**Fichiers créés :** `Services/DeadlineCalculator.swift`.

**Concept :** ne jamais ajouter `86400 * jours` secondes : les changements d'heure faussent le calcul. `Calendar` gère les jours, mois et fuseaux correctement, comme `date-fns` ou `Luxon` en JavaScript.

**Terminé quand :** saisir une date d'expiration affiche les échéances calculées selon le JSON.

**Durée :** 1 h

---

- [ ] **6.3 Bouton "Ajouter au calendrier" (EventKit sans accès complet)**

**Objectif :** proposer l'écran natif d'ajout d'événement, sans demander l'autorisation d'accès au calendrier.

**Étapes (en code) :**
1. Créer `Features/Reminders/AddToCalendarSheet.swift` : un `UIViewControllerRepresentable` qui enveloppe `EKEventEditViewController`.
2. Préremplir l'événement : titre, date de début et de fin, lieu, notes (incluant la mention "service indépendant").
3. Gérer la fermeture via un `Coordinator` qui implémente `EKEventEditViewDelegate`.
4. **Ne pas** appeler `requestFullAccessToEvents` et **ne pas** ajouter la clé `NSCalendarsFullAccessUsageDescription`. Depuis iOS 17, cet écran s'exécute hors de l'app et ne demande aucune permission.
5. Tester sur iPhone réel : l'utilisateur choisit lui-même le calendrier et valide.

**Commandes :** aucune.

**Fichiers créés :** `Features/Reminders/AddToCalendarSheet.swift`.

**Concept :** SwiftUI ne couvre pas tout ; certains écrans système existent seulement en UIKit (l'ancien framework). `UIViewControllerRepresentable` sert de pont, comme envelopper une librairie JavaScript non React dans un composant avec `useRef` et `useEffect`. Le `Coordinator` reçoit les événements (les "delegates" UIKit), comme des callbacks passés à la librairie.

**Terminé quand :** sur iPhone, le bouton ouvre l'écran d'ajout prérempli et l'événement apparaît dans Calendrier, sans aucune alerte de permission.

**Durée :** 2 h

---

- [ ] **6.4 Service de notifications locales**

**Objectif :** programmer des rappels avant chaque rendez-vous et échéance.

**Étapes (en code) :**
1. Dans `Services/`, créer `NotificationService` avec :
   - `requestAuthorization()` qui appelle `UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])`,
   - `schedule(reminder:offsets:)` avec un `UNCalendarNotificationTrigger`,
   - `cancel(reminder:)` à partir de `notificationId`.
2. Demander l'autorisation **au moment** où l'utilisateur active un rappel, jamais au lancement de l'app.
3. Rappels par défaut (provisoires, voir Questions ouvertes) : 7 jours avant et 1 jour avant.
4. Rédiger le texte de la notification dans la langue choisie au moment de la programmation.

**Commandes :** aucune.

**Fichiers créés :** `Services/NotificationService.swift`.

**Concept :** les notifications locales sont programmées par l'app elle-même, sans serveur (contrairement aux notifications push). C'est comme un `setTimeout` qui survit à la fermeture de l'app, géré par iOS. Demander la permission au bon moment, avec une explication, augmente fortement le taux d'acceptation.

**Terminé quand :** un rappel programmé 2 minutes plus tard s'affiche sur l'iPhone, app fermée.

**Durée :** 1 h 30

---

- [ ] **6.5 Gérer refus, modification et suppression**

**Objectif :** un comportement correct quand l'utilisateur refuse les notifications ou modifie un rendez-vous.

**Étapes (en code) :**
1. Si l'autorisation est refusée, afficher une explication et un bouton vers les réglages iOS.
2. Modifier un rendez-vous annule et reprogramme ses notifications.
3. Supprimer un rendez-vous annule ses notifications.
4. "Recommencer le questionnaire" (4.6) ne supprime pas les rendez-vous (décision à confirmer, voir Questions ouvertes).

**Commandes :** aucune.

**Fichiers modifiés :** `Services/NotificationService.swift`, `Features/Reminders/*.swift`.

**Concept :** `UNUserNotificationCenter.current().notificationSettings()` donne l'état courant de l'autorisation ; on le relit à chaque retour au premier plan (`scenePhase`), car l'utilisateur peut changer d'avis dans les réglages.

**Terminé quand :** aucun rappel "fantôme" ne subsiste après suppression ou modification.

**Durée :** 1 h

---

- [ ] **6.6 Tester sur appareil réel**

**Objectif :** valider calendrier et notifications dans des conditions réelles.

**Étapes (à la main) :**
1. Installer sur l'iPhone, parcourir : saisie de rendez-vous, ajout au calendrier, rappel proche.
2. Tester app fermée, téléphone verrouillé, mode Concentration.
3. Tester le refus de permission, puis l'activation depuis les réglages.
4. Noter les problèmes dans ce fichier.

**Commandes :**
```bash
xcrun simctl push booted <bundle-id> notif.apns   # (optionnel) simuler l'affichage d'une notification sur simulateur
```

**Fichiers :** aucun.

**Concept :** le simulateur ne reproduit pas fidèlement l'heure système, le verrouillage ni les modes Concentration. Pour ces fonctions, seul l'appareil réel fait foi.

**Terminé quand :** les quatre scénarios fonctionnent sur iPhone.

**Durée :** 1 h

---

## Phase 7 : traductions

Objectif de la phase : 100 % de l'interface et du contenu en français et en anglais, dates et nombres au bon format, prêts pour l'arabe.

- [ ] **7.1 Compléter le String Catalog**

**Objectif :** traduire toutes les chaînes de l'interface.

**Étapes :**
1. (À la main) Compiler, ouvrir `Localizable.xcstrings`, filtrer les chaînes non traduites.
2. Traduire en anglais. Ajouter un commentaire pour le traducteur sur les chaînes ambiguës.
3. (En code) Pour les textes hors vue (notifications, alertes), utiliser `String(localized: "...")` avec la locale choisie.
4. Gérer les pluriels ("1 document" / "3 documents") avec "Vary by Plural" dans le catalogue.
5. Supprimer les chaînes marquées "Stale" (plus utilisées).

**Commandes :** aucune.

**Fichiers modifiés :** `Resources/Localizable.xcstrings`, vues concernées.

**Concept :** `Text("Bonjour")` reçoit en réalité une `LocalizedStringKey` : SwiftUI cherche automatiquement la traduction. `Text(maVariable)` avec une `String` n'est **pas** traduit. C'est la différence entre `t("cle")` et afficher une variable brute en i18next. L'interpolation `Text("\(count) documents")` crée une clé avec paramètre.

**Terminé quand :** le catalogue est à 100 % pour les deux langues, sans chaîne "Stale".

**Durée :** 1 h 30

---

- [ ] **7.2 Traduire le nom et les textes système**

**Objectif :** traduire ce qui est dans `Info.plist` (nom affiché, textes de permission).

**Étapes (à la main) :**
1. File > New > File from Template > String Catalog, nommé `InfoPlist`.
2. Compiler : `CFBundleDisplayName` et les éventuelles clés de permission apparaissent.
3. Traduire (le nom "Check Pap" reste identique, à confirmer).

**Commandes :** aucune.

**Fichiers créés :** `Resources/InfoPlist.xcstrings`.

**Concept :** `Info.plist` est le manifeste de l'app (comme `manifest.json` d'une PWA). Ses textes visibles se traduisent dans un catalogue séparé.

**Terminé quand :** l'iPhone en anglais affiche les textes système en anglais.

**Durée :** 30 min

---

- [ ] **7.3 Valider les traductions du contenu JSON**

**Objectif :** garantir qu'aucun texte JSON ne manque dans une langue.

**Étapes :**
1. (En code) Écrire `scripts/validate_content.py` qui parcourt tous les JSON et signale : tout objet traduit sans `fr` ou `en`, tout `lastVerified` absent, toute URL non `https`, tout texte contenant `[PROVISOIRE]` (avertissement).
2. Traduire en anglais tout le contenu provisoire.
3. Lancer le script avant chaque commit touchant au contenu.

**Commandes :**
```bash
python3 scripts/validate_content.py CheckPap/Resources/Content
```

**Fichiers créés :** `scripts/validate_content.py`.

**Concept :** pas de Swift ici : on utilise l'outil qu'on maîtrise (Python) pour valider des données. La même validation sera faite en Swift dans les tests (9.3) pour bloquer une compilation de test si le contenu est incomplet.

**Terminé quand :** le script ne signale aucune erreur (seulement les avertissements `[PROVISOIRE]`).

**Durée :** 1 h 30

---

- [ ] **7.4 Dates, heures et nombres localisés**

**Objectif :** formater les dates selon la langue choisie dans l'app.

**Étapes (en code) :**
1. Remplacer tout formatage manuel par `date.formatted(.dateTime.day().month(.wide).year())` avec la locale de l'environnement.
2. Vérifier que "dernière vérification le 12 octobre 2026" devient "last verified on October 12, 2026".
3. Vérifier l'heure (24 h en français, selon le réglage iOS en anglais).

**Commandes :** aucune.

**Fichiers modifiés :** `Shared/` et vues concernées.

**Concept :** les "format styles" Swift ressemblent à `Intl.DateTimeFormat` en JavaScript : on décrit ce qu'on veut afficher, la locale décide de l'ordre et des mots.

**Terminé quand :** toutes les dates s'affichent correctement dans les deux langues.

**Durée :** 1 h

---

- [ ] **7.5 Préparer l'ajout de l'arabe**

**Objectif :** documenter et tester ce qu'il faudra faire pour ajouter une langue droite à gauche.

**Étapes :**
1. (À la main) Refaire le test pseudo-langue droite à gauche (3.4) sur tous les écrans.
2. (En documentation) Créer `docs/ajouter-une-langue.md` : ajouter la localisation au projet, au catalogue, la clé dans chaque JSON, le cas dans `AppLanguage`, vérifier la police.
3. (À la main) Vérifier avec la pseudo-langue "Double-Length" que les textes longs ne cassent rien (Scheme > Options > App Language).

**Commandes :** aucune.

**Fichiers créés :** `docs/ajouter-une-langue.md`.

**Concept :** les pseudo-langues de Xcode simulent des problèmes réels (textes plus longs comme en allemand, sens inversé comme en arabe) sans avoir de traduction.

**Terminé quand :** la procédure est écrite et les deux pseudo-langues passent sans défaut visible.

**Durée :** 1 h

---

## Phase 8 : écrans légaux et mentions

Objectif de la phase : toutes les mentions de protection sont présentes et cohérentes, et le contenu respecte les garde-fous.

- [ ] **8.1 Composant de mention "service indépendant"**

**Objectif :** un composant unique, réutilisé partout, pour la mention obligatoire.

**Étapes (en code) :**
1. Dans `Shared/`, créer `IndependentServiceNotice` : "Service indépendant. Les démarches officielles sont gratuites." avec un lien vers l'écran "À propos".
2. L'afficher sur : choix de la langue, accueil de la démarche, liste, chaque fiche document, guide de rendez-vous.
3. Style neutre : couleurs de l'app, aucune couleur tricolore.

**Commandes :** aucune.

**Fichiers créés :** `Shared/IndependentServiceNotice.swift`.

**Concept :** un seul composant = un seul texte à faire valider et traduire. Comme en React, la réutilisation garantit la cohérence.

**Terminé quand :** la mention est visible sur les cinq écrans listés.

**Durée :** 45 min

---

- [ ] **8.2 Composant "dernière vérification"**

**Objectif :** afficher la date de vérification sur chaque fiche, de façon uniforme.

**Étapes (en code) :**
1. Créer `Shared/LastVerifiedLabel.swift` : "Informations vérifiées le ..." + source.
2. L'utiliser sur l'accueil de la démarche, chaque fiche document, le guide de rendez-vous, chaque fiche consulat.
3. Si la date a plus de N jours (N défini dans le JSON), afficher un avertissement "Ces informations peuvent avoir changé".

**Commandes :** aucune.

**Fichiers créés :** `Shared/LastVerifiedLabel.swift`.

**Concept :** même logique que 8.1. Le seuil N est du contenu, donc dans le JSON, pas dans le code.

**Terminé quand :** chaque fiche affiche sa date et l'avertissement apparaît quand on vieillit artificiellement une date.

**Durée :** 45 min

---

- [ ] **8.3 Écran "À propos et mentions légales"**

**Objectif :** informer clairement sur l'éditeur, les limites du service et les sources.

**Étapes (en code) :**
1. Dans `Features/Legal/`, créer `AboutView` avec des sections :
   - Qui édite l'app (nom, contact).
   - Service indépendant, sans lien avec l'administration ; démarches officielles gratuites.
   - Pas de conseil juridique ; pas de garantie de résultat ; vérifier auprès de la préfecture.
   - Sources du contenu et méthode de vérification.
   - Où trouver une aide gratuite (lien vers les points d'accès au droit, à valider).
   - Version de l'app et version du contenu.
2. Textes stockés dans le String Catalog (ou dans un JSON `legal.json` si on veut les mettre à jour sans nouvelle version : voir Questions ouvertes).
3. Accès depuis les réglages et depuis la mention 8.1.

**Commandes :** aucune.

**Fichiers créés :** `Features/Legal/AboutView.swift`.

**Concept :** lire la version de l'app : `Bundle.main.infoDictionary?["CFBundleShortVersionString"]`. C'est l'équivalent de lire `version` dans `package.json` à l'exécution.

**Terminé quand :** l'écran est complet dans les deux langues et relu.

**Durée :** 1 h 30

---

- [ ] **8.4 Écran de confidentialité dans l'app**

**Objectif :** expliquer simplement quelles données existent et où elles restent.

**Étapes (en code) :**
1. Créer `Features/Legal/PrivacyView` : aucune donnée envoyée, tout reste sur le téléphone, pas de compte, pas de suivi publicitaire ; calendrier uniquement via l'écran système ; notifications locales.
2. Bouton "Effacer toutes mes données" (supprime sessions et rappels, annule les notifications) avec confirmation.
3. Lien vers la politique publiée en ligne (10.5).

**Commandes :** aucune.

**Fichiers créés :** `Features/Legal/PrivacyView.swift`.

**Concept :** supprimer toutes les données SwiftData : `try modelContext.delete(model: ChecklistSession.self)`. Penser à annuler aussi les notifications, qui vivent hors de la base.

**Terminé quand :** "Effacer toutes mes données" ramène l'app à l'état du premier lancement (hors choix de langue).

**Durée :** 1 h

---

- [ ] **8.5 Revue des garde-fous**

**Objectif :** vérifier mot par mot le respect des garde-fous avant les tests.

**Étapes (à la main) :**
1. Chercher le mot "officiel" dans tous les textes et vérifier chaque occurrence (voir la règle précisée dans Questions ouvertes).
2. Chercher les formulations de promesse : "garanti", "sûr d'obtenir", "vous obtiendrez", "guaranteed".
3. Vérifier qu'aucune image, icône ou couleur ne rappelle un logo ou un code couleur de l'État (Marianne, bleu-blanc-rouge, typographie de l'État).
4. Vérifier que la date de vérification est sur chaque fiche.
5. Noter le résultat de la revue ici avec la date.

**Commandes :**
```bash
grep -rniE "officiel|official" CheckPap/Resources docs
grep -rniE "garanti|guarantee|promis|assur[ée]" CheckPap/Resources
```

**Fichiers :** corrections éventuelles.

**Concept :** pas de concept Swift ; c'est une revue de conformité. Les mêmes vérifications seront automatisées en 9.3.

**Terminé quand :** chaque occurrence trouvée est justifiée ou corrigée, et la revue est datée ici.

**Durée :** 1 h

---

## Phase 9 : tests

Objectif de la phase : la logique et le contenu sont vérifiés automatiquement ; le parcours complet est vérifié à la main sur plusieurs configurations.

- [ ] **9.1 Tests du décodage du contenu**

**Objectif :** tous les JSON fournis se décodent sans erreur.

**Étapes (en code) :**
1. Dans `CheckPapTests/`, créer `ContentDecodingTests.swift`.
2. Un test par fichier : décodage réussi, nombre de questions et documents supérieur à zéro.
3. Un test avec un JSON volontairement invalide qui doit échouer.
4. Lancer avec Cmd+U ou en ligne de commande.

**Commandes :**
```bash
xcrun simctl list devices available | grep iPhone   # choisir un nom de simulateur
xcodebuild test -scheme CheckPap -destination 'platform=iOS Simulator,name=<NOM DU SIMULATEUR>'
```

**Fichiers créés :** `CheckPapTests/ContentDecodingTests.swift`.

**Concept :** Swift Testing : `@Test func ...()` et `#expect(condition)`, l'équivalent de `it("...", () => {})` et `expect(...)` de Jest ou Vitest. `#require` arrête le test si la condition échoue, comme un `expect` bloquant.

**Terminé quand :** tous les tests passent en local.

**Durée :** 1 h

---

- [ ] **9.2 Tests du moteur de règles**

**Objectif :** vérifier chaque opérateur de condition et des parcours types.

**Étapes (en code) :**
1. Créer `RulesEngineTests.swift` avec des démarches de test construites dans le code (pas le vrai contenu).
2. Un test par opérateur : `equals`, `in`, `all`, `any`, `not`, question sans réponse.
3. Un test paramétré de parcours : plusieurs jeux de réponses et la liste attendue.

**Commandes :** comme 9.1.

**Fichiers créés :** `CheckPapTests/RulesEngineTests.swift`.

**Concept :** `@Test(arguments: [...])` exécute le même test pour chaque entrée, comme `it.each` en Jest.

**Terminé quand :** chaque opérateur a au moins un test positif et un négatif, tous verts.

**Durée :** 1 h 30

---

- [ ] **9.3 Tests de conformité du contenu**

**Objectif :** bloquer automatiquement un contenu incomplet ou contraire aux garde-fous.

**Étapes (en code) :**
1. Créer `ContentComplianceTests.swift` :
   - chaque texte traduit a toutes les langues supportées,
   - chaque fiche a une date `lastVerified`,
   - chaque lien est en `https`,
   - aucune condition ne référence une question inexistante,
   - aucun mot interdit hors liste d'exceptions,
   - (en mode publication) aucun texte `[PROVISOIRE]`.

**Commandes :** comme 9.1.

**Fichiers créés :** `CheckPapTests/ContentComplianceTests.swift`.

**Concept :** des tests sur les données, pas sur le code. Ils transforment les garde-fous en règles vérifiées à chaque exécution des tests.

**Terminé quand :** les tests passent, et cassent bien si on retire volontairement une traduction.

**Durée :** 1 h 30

---

- [ ] **9.4 Tests de persistance SwiftData**

**Objectif :** vérifier la création de session, le cochage et la synchronisation de contenu (5.6).

**Étapes (en code) :**
1. Créer un conteneur en mémoire : `ModelConfiguration(isStoredInMemoryOnly: true)`.
2. Tester : création de session, cochage, suppression en cascade, synchronisation après changement de version.

**Commandes :** comme 9.1.

**Fichiers créés :** `CheckPapTests/PersistenceTests.swift`.

**Concept :** une base en mémoire est rapide et repart de zéro à chaque test, comme une base SQLite `:memory:` dans les tests Laravel.

**Terminé quand :** les quatre scénarios sont couverts et verts.

**Durée :** 1 h

---

- [ ] **9.5 Test UI du parcours complet**

**Objectif :** un test automatique qui parcourt l'app comme un utilisateur.

**Étapes (en code) :**
1. Dans l'app, lire un argument de lancement `-uitesting` qui utilise une base en mémoire et réinitialise le choix de langue.
2. Ajouter des `.accessibilityIdentifier` sur les éléments clés.
3. Dans `CheckPapUITests/`, écrire le parcours : langue, accueil, réponses, récapitulatif, liste, cocher un document, ouvrir une fiche.
4. Le faire tourner en français et en anglais.

**Commandes :** comme 9.1.

**Fichiers créés :** `CheckPapUITests/MainFlowUITests.swift`. **Modifiés :** vues (identifiants), `App/CheckPapApp.swift`.

**Concept :** XCUITest pilote l'app depuis l'extérieur, comme Playwright ou Cypress pour le web. Les identifiants d'accessibilité jouent le rôle des `data-testid`.

**Terminé quand :** le test passe dans les deux langues.

**Durée :** 2 h

---

- [ ] **9.6 Campagne de tests manuels**

**Objectif :** vérifier ce que les tests automatiques ne voient pas.

**Étapes (à la main) :** cocher chaque ligne.
- [ ] Simulateur iOS 17 (version minimale)
- [ ] Plus petit iPhone disponible
- [ ] Plus grand iPhone disponible
- [ ] Mode sombre
- [ ] Taille de texte maximale (Accessibility Inspector)
- [ ] VoiceOver sur iPhone réel, parcours complet
- [ ] Pseudo-langue droite à gauche
- [ ] Mode avion (l'app fonctionne entièrement hors ligne)
- [ ] Changement de langue en cours de parcours
- [ ] Mise à jour de l'app avec données existantes (installer une ancienne version, puis la nouvelle)

**Commandes :** aucune.

**Fichiers :** `suivi.md` (résultats).

**Concept :** l'Accessibility Inspector audite automatiquement un écran (contraste, libellés manquants, tailles de zones tactiles) : bouton "Run Audit".

**Terminé quand :** toutes les lignes sont cochées, ou les défauts restants sont listés et acceptés.

**Durée :** 1 h

---

## Phase 10 : préparation de la soumission App Store

Objectif de la phase : tout ce qu'Apple demande est prêt avant le premier envoi.

- [ ] **10.1 Icône de l'app**

**Objectif :** une icône originale, sans symbole ni couleur gouvernementale.

**Étapes :**
1. Concevoir une icône 1024 x 1024 px, sans transparence, sans texte petit.
2. (À la main) `Resources/Assets.xcassets` > AppIcon : déposer l'image (format unique, Xcode génère les tailles). Si Xcode propose Icon Composer, l'utiliser pour les variantes clair, sombre et teinté.
3. Vérifier sur l'écran d'accueil de l'iPhone en mode clair et sombre.

**Commandes :** aucune.

**Fichiers modifiés :** `Resources/Assets.xcassets/AppIcon.appiconset/` (ou fichier `.icon`).

**Concept :** iOS applique lui-même le masque arrondi ; il ne faut pas arrondir les coins dans l'image.

**Terminé quand :** l'icône s'affiche correctement sur l'iPhone dans tous les modes.

**Durée :** 1 h 30 (hors conception graphique).

---

- [ ] **10.2 Couleur d'accent et écran de lancement**

**Objectif :** une identité visuelle propre et neutre.

**Étapes :**
1. (À la main) `Assets.xcassets` > AccentColor : choisir une couleur de marque (variantes clair et sombre) qui ne rappelle pas le code couleur de l'État.
2. (À la main) Cible > Info > "Launch Screen" : définir une couleur de fond (clé `UILaunchScreen`).

**Commandes :** aucune.

**Fichiers modifiés :** `Assets.xcassets`, réglages de la cible.

**Concept :** l'écran de lancement s'affiche pendant le chargement ; Apple demande qu'il ressemble au premier écran, sans logo publicitaire.

**Terminé quand :** le lancement est fluide et cohérent en clair et en sombre.

**Durée :** 30 min

---

- [ ] **10.3 Manifeste de confidentialité**

**Objectif :** déclarer à Apple les API sensibles utilisées et l'absence de collecte.

**Étapes (à la main) :**
1. File > New > File from Template > App Privacy, nommé `PrivacyInfo.xcprivacy`, dans `Resources/`, cible CheckPap cochée.
2. Renseigner :
   - `NSPrivacyTracking` : NO.
   - `NSPrivacyCollectedDataTypes` : vide.
   - `NSPrivacyAccessedAPITypes` : User Defaults avec la raison `CA92.1` (accès aux données de l'app elle-même).
3. Vérifier lors de l'archivage (11.1) via Organizer > Generate Privacy Report.

**Commandes :** aucune.

**Fichiers créés :** `Resources/PrivacyInfo.xcprivacy`.

**Concept :** Apple exige de justifier l'usage de certaines API (dont `UserDefaults`, utilisé par `@AppStorage`) avec un code de raison, pour limiter l'identification des appareils. Sans ce fichier, l'envoi peut être refusé.

**Terminé quand :** le fichier est dans l'app et le rapport de confidentialité ne signale rien d'inattendu.

**Durée :** 30 min

---

- [ ] **10.4 Déclaration de chiffrement**

**Objectif :** éviter la question de conformité d'export à chaque envoi.

**Étapes (à la main) :**
1. Cible > Info > ajouter la clé "App Uses Non-Exempt Encryption" (`ITSAppUsesNonExemptEncryption`) = NO.

**Commandes :** aucune.

**Fichiers modifiés :** réglages Info de la cible.

**Concept :** l'app n'utilise que le chiffrement standard d'iOS (HTTPS) : elle est exemptée. Déclarer la clé évite de répondre manuellement dans App Store Connect pour chaque build.

**Terminé quand :** la clé est présente dans le `Info.plist` généré.

**Durée :** 10 min

---

- [ ] **10.5 Publier la politique de confidentialité et la page d'assistance**

**Objectif :** deux URL publiques exigées par App Store Connect.

**Étapes :**
1. (En code) Créer `docs/site/index.html` (assistance : contact, FAQ, mention service indépendant) et `docs/site/confidentialite.html` (FR et EN).
2. Publier avec GitHub Pages, ou sur un hébergement existant (voir Questions ouvertes). Avec GitHub Pages, le dépôt doit être public ou le compte payant : alternative, un petit dépôt public séparé `check-pap-site`.
3. Vérifier que les pages s'ouvrent sur mobile.

**Commandes :**
```bash
gh repo create check-pap-site --public
# puis activer Pages : Settings > Pages > Branch main / root
```

**Fichiers créés :** `docs/site/index.html`, `docs/site/confidentialite.html`.

**Concept :** pas de Swift ; c'est votre terrain (web). Le contenu doit correspondre exactement à l'écran 8.4 et aux réponses "App Privacy" (10.8).

**Terminé quand :** les deux URL répondent en HTTPS.

**Durée :** 1 h 30

---

- [ ] **10.6 Captures d'écran**

**Objectif :** des captures propres en français et en anglais.

**Étapes :**
1. Vérifier sur App Store Connect la taille d'écran iPhone exigée au moment de l'envoi (actuellement une seule taille obligatoire, les autres sont réduites automatiquement).
2. (Terminal) Démarrer le simulateur correspondant, forcer une barre d'état propre.
3. Préparer un jeu de données de démonstration réaliste (pas de vraie donnée personnelle).
4. Capturer 4 à 6 écrans par langue : choix de langue, questionnaire, liste, fiche document, rappels.
5. Aucune capture ne doit montrer "officiel" pour décrire l'app, ni un logo de l'État.

**Commandes :**
```bash
xcrun simctl boot "<NOM DU SIMULATEUR>"
xcrun simctl status_bar booted override --time "9:41" --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3
xcrun simctl io booted screenshot exports/fr-01-langue.png
xcrun simctl status_bar booted clear
```

**Fichiers créés :** `exports/*.png` (non versionnés).

**Concept :** `simctl` pilote les simulateurs depuis le Terminal, pratique pour des captures reproductibles.

**Terminé quand :** chaque langue a ses captures aux bonnes dimensions.

**Durée :** 1 h 30

---

- [ ] **10.7 Rédiger la fiche App Store**

**Objectif :** des textes FR et EN conformes aux limites et aux garde-fous.

**Étapes :**
1. (En documentation) Rédiger `docs/appstore/fr.md` et `docs/appstore/en.md` :
   - Nom (30 caractères max) : Check Pap.
   - Sous-titre (30).
   - Texte promotionnel (170).
   - Description (4000) : commencer par ce que fait l'app, inclure "service indépendant, démarches officielles gratuites", aucune promesse.
   - Mots-clés (100, séparés par des virgules, sans espaces inutiles).
   - URL d'assistance et de confidentialité.
   - Catégorie principale et secondaire (voir Questions ouvertes).
2. (À la main) Saisir dans App Store Connect > version 1.0 > chaque langue.

**Commandes :** aucune.

**Fichiers créés :** `docs/appstore/fr.md`, `docs/appstore/en.md`.

**Concept :** le mot "officiel" et les éléments graphiques gouvernementaux dans les métadonnées sont aussi un motif de rejet (métadonnées trompeuses). Les textes de la fiche suivent les mêmes garde-fous que l'app.

**Terminé quand :** les deux langues sont saisies sans dépassement de longueur.

**Durée :** 1 h 30

---

- [ ] **10.8 Questionnaires App Store Connect**

**Objectif :** remplir les rubriques obligatoires hors textes.

**Étapes (à la main dans App Store Connect) :**
1. App Privacy : "Data Not Collected" (cohérent avec 10.3 et 10.5).
2. Classification par âge : répondre au questionnaire (aucun contenu sensible).
3. Prix et disponibilité : gratuit ; pays (voir Questions ouvertes).
4. Droits sur le contenu : indiquer que l'app n'utilise pas de contenu tiers protégé (le contenu est rédigé par vous, à partir de sources publiques).
5. Informations de vérification : coordonnées du contact.

**Commandes :** aucune.

**Fichiers :** aucun.

**Concept :** ces réponses sont publiques (étiquette de confidentialité de la fiche). Elles doivent correspondre exactement au comportement réel de l'app.

**Terminé quand :** App Store Connect n'affiche plus d'avertissement sur ces rubriques.

**Durée :** 45 min

---

- [ ] **10.9 Notes pour l'équipe de vérification d'Apple**

**Objectif :** anticiper les questions de l'équipe App Review.

**Étapes (en documentation) :**
1. Rédiger `docs/appstore/review-notes.md` (en anglais) :
   - l'app est un service indépendant, non affilié à l'administration française ;
   - elle ne donne pas de conseil juridique et renvoie vers les sources publiques ;
   - liste des sources du contenu ;
   - aucune connexion, aucune donnée collectée ;
   - comment tester le parcours (aucun compte nécessaire).
2. Retirer tout texte `[PROVISOIRE]` du contenu avant envoi pour la vérification App Store (le contenu final doit être validé, voir Questions ouvertes).

**Commandes :**
```bash
grep -rn "\[PROVISOIRE\]" CheckPap/Resources/Content && echo "CONTENU PROVISOIRE PRÉSENT" || echo "OK"
```

**Fichiers créés :** `docs/appstore/review-notes.md`.

**Concept :** Apple vérifie particulièrement les apps qui touchent aux démarches publiques : elles doivent montrer clairement qu'elles ne se font pas passer pour l'administration et qu'elles apportent une vraie valeur au-delà d'un simple lien vers un site.

**Terminé quand :** les notes sont prêtes et la commande affiche "OK".

**Durée :** 45 min

---

## Phase 11 : TestFlight puis App Store

Objectif de la phase : une version testée par de vrais utilisateurs, puis publiée.

- [ ] **11.1 Archiver la première version**

**Objectif :** produire un build signé pour la distribution.

**Étapes (à la main dans Xcode) :**
1. Vérifier Version (`1.0.0`) et Build (incrémenté).
2. Sélectionner la destination "Any iOS Device (arm64)".
3. Product > Archive. L'Organizer s'ouvre.
4. Sélectionner l'archive > "Validate App" : corriger toute erreur.
5. Générer le rapport de confidentialité (bouton dans l'Organizer) et le relire.

**Commandes :**
```bash
git tag build-1 && git push --tags
```

**Fichiers :** archive dans `~/Library/Developer/Xcode/Archives`.

**Concept :** un archivage compile en configuration "Release" (optimisée, sans outils de débogage), comme `npm run build` par rapport à `npm run dev`.

**Terminé quand :** "Validate App" réussit sans erreur.

**Durée :** 45 min

---

- [ ] **11.2 Envoyer le build à App Store Connect**

**Objectif :** rendre le build disponible pour TestFlight.

**Étapes (à la main) :**
1. Organizer > "Distribute App" > "App Store Connect" > Upload, signature automatique.
2. Attendre le traitement (de quelques minutes à une heure ; un email arrive).
3. Vérifier dans App Store Connect > TestFlight que le build apparaît sans avertissement de conformité.

**Commandes :** aucune.

**Fichiers :** aucun.

**Concept :** Apple recompile et analyse le build côté serveur. Un build traité est utilisable à la fois pour TestFlight et pour la soumission App Store.

**Terminé quand :** le build est "Ready to Test" (prêt à tester).

**Durée :** 30 min (+ attente)

---

- [ ] **11.3 TestFlight interne**

**Objectif :** tester sur ses appareils via TestFlight, comme un utilisateur.

**Étapes (à la main) :**
1. App Store Connect > TestFlight > Internal Testing > créer un groupe, s'y ajouter (et les membres de l'équipe).
2. Installer l'app TestFlight sur l'iPhone, accepter l'invitation.
3. Refaire le parcours complet de 9.6 sur ce build.

**Commandes :** aucune.

**Fichiers :** `suivi.md` (résultats).

**Concept :** les testeurs internes (membres de l'équipe App Store Connect) n'ont pas besoin de vérification Apple : le build est disponible tout de suite.

**Terminé quand :** le parcours complet fonctionne sur le build TestFlight.

**Durée :** 45 min

---

- [ ] **11.4 TestFlight externe**

**Objectif :** faire tester par des personnes concernées (étudiants étrangers, associations).

**Étapes (à la main) :**
1. TestFlight > External Testing > nouveau groupe.
2. Renseigner les informations de test : description, email de retour, ce qu'il faut tester (FR et EN).
3. Ajouter le build : il part en vérification "Beta App Review" (souvent moins de 48 h).
4. Inviter par email ou créer un lien public, limité en nombre.
5. Préparer 5 questions de retour (compréhension, confiance, manques, langue, bugs).

**Commandes :** aucune.

**Fichiers :** `docs/testflight-retours.md` (créé).

**Concept :** un lien public TestFlight se partage comme un lien d'invitation ; il expire au bout de 90 jours par build.

**Terminé quand :** au moins 5 testeurs externes ont installé l'app et donné un retour.

**Durée :** 1 h (+ attente des retours)

---

- [ ] **11.5 Intégrer les retours et renvoyer un build**

**Objectif :** corriger ce qui bloque avant la publication.

**Étapes :**
1. Trier les retours : bloquant, important, plus tard.
2. Corriger les bloquants (chaque correction = une petite tâche ajoutée ici).
3. Incrémenter le Build, archiver, envoyer (11.1 et 11.2).

**Commandes :**
```bash
git tag build-2 && git push --tags
```

**Fichiers :** selon les corrections.

**Concept :** le numéro de Build doit toujours augmenter ; la Version (`1.0.0`) peut rester la même tant que l'app n'est pas publiée.

**Terminé quand :** aucun retour bloquant ne reste ouvert.

**Durée :** 1 h hors corrections.

---

- [ ] **11.6 Soumettre à la vérification App Store**

**Objectif :** envoyer la version 1.0 à Apple.

**Étapes (à la main dans App Store Connect) :**
1. Version 1.0 > sélectionner le build.
2. Vérifier : captures, textes FR et EN, URL, App Privacy, classification, notes de vérification (10.9).
3. Choisir "Publication manuelle" pour décider du jour de sortie.
4. "Ajouter pour vérification", puis "Soumettre".

**Commandes :** aucune.

**Fichiers :** aucun.

**Concept :** la vérification prend en général 24 à 48 h. En cas de rejet, Apple cite la règle concernée (App Review Guidelines) dans le centre de résolution ; on répond ou on corrige.

**Terminé quand :** le statut passe à "Waiting for Review" (en attente de vérification).

**Durée :** 45 min

---

- [ ] **11.7 Publication et suivi**

**Objectif :** publier l'app et garder une trace.

**Étapes :**
1. (À la main) À l'acceptation, cliquer "Publier cette version".
2. (Terminal) Taguer la version publiée.
3. (À la main) Vérifier la fiche publique sur l'App Store en FR et EN.
4. (À la main) Surveiller les plantages : Xcode > Window > Organizer > Crashes.
5. Mettre à jour ce fichier : date de publication, prochaine étape.

**Commandes :**
```bash
git tag v1.0.0 && git push --tags
```

**Fichiers :** `suivi.md`.

**Concept :** l'Organizer reçoit les rapports de plantage des utilisateurs ayant accepté le partage avec les développeurs, sans aucun outil tiers.

**Terminé quand :** l'app est téléchargeable sur l'App Store et le tag `v1.0.0` est poussé.

**Durée :** 30 min

---

## Questions ouvertes

À trancher au fil du projet. Indiquer la décision et la date à côté de chaque question une fois tranchée.

**Contenu et responsabilité**
1. Qui valide le contenu de la démarche avant publication (juriste, association, relecture croisée) ? Le contenu `[PROVISOIRE]` ne doit pas partir sur l'App Store.
2. Règle exacte pour le mot "officiel" : la mention imposée contient "démarches officielles gratuites" et le parcours parle de "liens officiels". Proposition : interdit pour qualifier l'app ou son contenu ; autorisé uniquement dans la mention imposée et pour désigner les sites de l'administration ("site de la préfecture" plutôt que "lien officiel" quand c'est possible).
3. Quel délai avant d'afficher "ces informations peuvent avoir changé" (seuil N de 8.2) ?
4. Quelles valeurs provisoires pour les échéances (par exemple : déposer la demande X jours avant l'expiration du titre) et qui les vérifie ?
5. Quels pays dans l'annuaire des consulats en v1, quelle source, quelle fréquence de vérification ?
6. Faut-il un lien vers des structures d'aide gratuite (points d'accès au droit, associations) ? Lesquelles ?
7. Les textes légaux doivent-ils être dans un JSON (modifiables sans nouvelle version) ou dans le String Catalog ?

**Technique**
8. Langue de développement des String Catalogs : français (textes du code en français, plus naturel pour vous) ou anglais (convention la plus courante, outils mieux rodés) ?
9. iPhone seulement, ou iPad aussi en v1 ? (Le plan suppose iPhone seulement, portrait.)
10. Format de chargement depuis le serveur plus tard : URL, version du schéma, mise en cache, signature ou somme de contrôle pour garantir l'intégrité.
11. Quels rappels par défaut (7 jours et 1 jour avant ?) et faut-il les rendre réglables ?
12. "Recommencer le questionnaire" doit-il supprimer aussi les rendez-vous et rappels ?
13. Garder une seule session ou un historique de plusieurs démarches (utile quand d'autres démarches arriveront) ?
14. Intégration continue (GitHub Actions sur runner macOS) dès la v1 ou plus tard ?
15. Aucun outil d'analyse d'usage en v1 (cohérent avec "Data Not Collected") : confirmé ?

**Publication**
16. Compte développeur individuel ou organisation ? Le nom du vendeur affiché sur l'App Store en dépend, ainsi que les mentions légales (éditeur).
17. Langue principale de la fiche App Store Connect : français ?
18. Catégorie App Store : Utilitaires, Productivité, Référence ou Éducation ?
19. Pays de disponibilité : France seulement, ou tous les pays (les futurs arrivants préparent souvent leur dossier depuis l'étranger) ?
20. Où héberger la politique de confidentialité et la page d'assistance (GitHub Pages, domaine propre) ? Faut-il réserver un nom de domaine ?
21. Adresse email de contact dédiée pour l'assistance ?
22. Qui conçoit l'icône et la palette de couleurs ?
23. Le nom "Check Pap" ("pap" pour "papiers") reste-t-il identique en anglais et dans les futures langues ?

**Couverture nationale**
24. Dans quel ordre vérifier les précisions locales des 101 préfectures (par nombre de demandes ? par département des premiers utilisateurs ?) et qui s'en charge ?
25. Préfecture de police de Paris : traitement à part (son organisation diffère des autres préfectures) ?
26. Outre-mer : inclus dès la v1 ? Certaines règles du CESEDA y sont adaptées ; à confirmer par l'inventaire.
27. Fréquence de mise à jour de l'annuaire des préfectures (régénération depuis l'annuaire officiel à chaque version de contenu ?).

- [ ] **Actualités automatiques** : tâche planifiée (GitHub Actions) qui lit l'API Légifrance (compte PISTE à créer) et les actualités de service-public, propose des brouillons d'articles en pull request, publication après validation humaine ; l'app télécharge `news.json` en ligne.
- [ ] **Traductions** : passer en anglais tous les nouveaux textes de l'interface (String Catalog).
- [ ] **Relecture humaine** de tout le contenu (statut "draft") et vérification des délais après le décret n°2026-1001.
