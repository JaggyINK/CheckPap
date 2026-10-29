# Schéma du contenu (version 1)

Tout le contenu administratif de l'app est dans `CheckPap/Resources/Content/`. Le code Swift ne contient aucune règle : il sait seulement lire ces fichiers et évaluer des conditions.

## Règles générales

- Chaque texte visible est un **texte traduit** : `{ "fr": "...", "en": "..." }`. Les deux langues sont obligatoires.
- Chaque question, pièce, étape et échéance référence au moins une **source** (champ `sources` : liste d'identifiants déclarés dans le tableau `sources` du fichier).
- Domaines autorisés pour les sources : `service-public.gouv.fr`, `service-public.fr`, `administration-etrangers-en-france.interieur.gouv.fr`, `interieur.gouv.fr`, `legifrance.gouv.fr`, `ofii.fr`, `france-visas.gouv.fr`, `demarches.interieur.gouv.fr`, `immigration.interieur.gouv.fr`, `data.gouv.fr`, `lannuaire.service-public.gouv.fr`, et les sites de préfecture en `.gouv.fr`.
- Identifiants : en `snake_case` ASCII, uniques dans le fichier.
- Ton : simple, phrases courtes, vouvoiement. On décrit ce que l'administration demande ("La préfecture demande...", "Le site indique..."), jamais un conseil juridique ni une promesse de résultat. On n'utilise pas le mot "officiel".
- Si une information n'a pas pu être vérifiée dans une source, elle n'entre pas dans le fichier ; elle va dans `reviewNotes`.

## `catalog.json`

```json
{
  "schemaVersion": 1,
  "contentVersion": "2026-10-29.1",
  "procedures": [
    {
      "id": "renewal",
      "symbol": "arrow.triangle.2.circlepath",
      "title": { "fr": "Renouveler mon titre de séjour", "en": "Renew my residence permit" },
      "subtitle": { "fr": "Mon titre arrive bientôt à expiration", "en": "My permit expires soon" }
    }
  ]
}
```

Chaque `id` correspond au fichier `procedures/<id>.json`. `symbol` est un nom de SF Symbol.

## `procedures/<id>.json`

```json
{
  "id": "renewal",
  "reviewStatus": "draft",
  "lastVerified": "2026-10-29",
  "title": { "fr": "...", "en": "..." },
  "summary": { "fr": "Deux ou trois phrases : à quoi sert cette démarche, pour qui.", "en": "..." },
  "sources": [
    {
      "id": "sp_renouvellement",
      "publisher": "service-public.gouv.fr",
      "title": "Titre exact de la page",
      "url": "https://...",
      "consulted": "2026-10-29"
    }
  ],
  "questions": [
    {
      "id": "permit_type",
      "kind": "single",
      "title": { "fr": "Quel titre de séjour avez-vous aujourd'hui ?", "en": "..." },
      "help": { "fr": "Pourquoi on vous le demande, ou où trouver l'information.", "en": "..." },
      "example": { "fr": "Exemple : il est écrit \"ÉTUDIANT\" sur votre carte.", "en": "..." },
      "options": [
        { "id": "student", "label": { "fr": "Étudiant", "en": "Student" }, "help": { "fr": "...", "en": "..." } }
      ],
      "condition": null,
      "sources": ["sp_renouvellement"]
    },
    {
      "id": "permit_expiry_date",
      "kind": "date",
      "title": { "fr": "Quelle est la date de fin de validité de votre titre ?", "en": "..." },
      "sources": ["..."]
    },
    {
      "id": "has_children_in_france",
      "kind": "yesNo",
      "title": { "fr": "...", "en": "..." },
      "condition": { "question": "permit_type", "equals": "private_family_life" },
      "sources": ["..."]
    }
  ],
  "documents": [
    {
      "id": "passport",
      "category": "identity",
      "title": { "fr": "Passeport", "en": "Passport" },
      "details": { "fr": "Ce qui est demandé exactement (pages, copie ou original, validité).", "en": "..." },
      "example": { "fr": "Exemple concret, facultatif.", "en": "..." },
      "tip": { "fr": "Astuce pratique tirée de la source, facultative.", "en": "..." },
      "condition": null,
      "sources": ["..."]
    }
  ],
  "steps": [
    {
      "id": "submit_online",
      "phase": "submit",
      "title": { "fr": "Déposer la demande en ligne", "en": "..." },
      "body": { "fr": "Explication courte, étape par étape.", "en": "..." },
      "link": { "title": { "fr": "Ouvrir le site de l'ANEF", "en": "Open the ANEF website" }, "url": "https://..." },
      "condition": null,
      "sources": ["..."]
    }
  ],
  "deadlines": [
    {
      "id": "file_window_start",
      "relativeTo": "permit_expiry_date",
      "offsetDays": -120,
      "title": { "fr": "Début de la période pour déposer la demande", "en": "..." },
      "condition": null,
      "sources": ["..."]
    }
  ],
  "reviewNotes": [
    "Texte libre en français : ce qui n'a pas pu être vérifié, contradictions entre sources, pages inaccessibles."
  ]
}
```

### Champs facultatifs

`help`, `example` (questions, pièces), `details` et `tip` (pièces), `options[].help`, `condition`, `link` (étapes), `deadlines`, `reviewNotes`. Un champ absent ou `null` est ignoré.

### Types de question (`kind`)

- `single` : un choix parmi `options` (2 à 8 options).
- `yesNo` : réponse `"yes"` ou `"no"` (pas de champ `options`).
- `date` : une date, enregistrée au format `AAAA-MM-JJ`. Sert aux échéances (`deadlines.relativeTo`).

Les questions s'affichent dans l'ordre du tableau. Une question dont la condition est fausse est sautée.

### Catégories de pièces (`category`)

`identity` (identité), `civil_status` (état civil), `residence` (séjour actuel), `address` (domicile), `photo` (photo et signature), `resources` (ressources), `work` (travail), `studies` (études), `family` (famille), `integration` (intégration, langue), `tax` (impôts et taxes), `other` (autre).

### Phases des étapes (`phase`)

`before` (avant de déposer), `submit` (dépôt), `after` (après le dépôt).

### Conditions

Une condition est un objet JSON, l'une de ces formes :

```json
{ "question": "permit_type", "equals": "student" }
{ "question": "permit_type", "in": ["student", "worker"] }
{ "all": [ <condition>, <condition> ] }
{ "any": [ <condition>, <condition> ] }
{ "not": <condition> }
{ "question": "permit_expiry_date", "daysFromToday": { "min": 0, "max": 89 } }
```

`daysFromToday` ne s'utilise que sur une question `date`. L'app calcule le nombre de jours entre aujourd'hui et la date saisie (négatif si la date est passée) et vérifie qu'il est entre `min` et `max` inclus. Chaque borne est facultative. Exemples :
- titre déjà expiré : `{ "max": -1 }` ;
- expire dans moins de 3 mois : `{ "min": 0, "max": 89 }` ;
- expire dans plus de 4 mois : `{ "min": 121 }`.

On ne pose donc **jamais** de question "combien de temps reste-t-il" en plus d'une date : on utilise la date.

Une condition portant sur une question sans réponse (sautée ou pas encore posée) est fausse. Une condition ne peut référencer qu'une question définie **plus haut** dans le tableau `questions`, et seulement des valeurs qui existent (`id` d'option, ou `"yes"` / `"no"`).

## Ordre des questions : l'entonnoir

Les questions vont **du plus général au plus précis** :
1. Situation de base (quel titre, quelle démarche, depuis quand).
2. Conditions principales de la démarche (celles qui peuvent orienter vers une autre démarche).
3. Questions de détail qui ne servent qu'à choisir les bonnes pièces.

Une question de détail n'est posée que si les réponses précédentes la rendent utile (`condition`).

## `outcomes` : orienter quand la situation ne correspond pas

Tableau facultatif dans `procedures/<id>.json`. Chaque élément décrit ce qu'on affiche quand une combinaison de réponses montre, **d'après les sources**, que la démarche ne correspond pas à la situation, ou qu'un point demande une attention particulière.

```json
{
  "id": "residence_too_short",
  "kind": "redirect",
  "condition": { "question": "residence_years", "equals": "less_than_5" },
  "title": { "fr": "Cette démarche ne semble pas correspondre à votre situation", "en": "..." },
  "body": { "fr": "Ce que dit la source, sans verdict : la condition, et ce qu'elle signifie concrètement.", "en": "..." },
  "actions": [
    {
      "title": { "fr": "Ce que vous pouvez faire", "en": "..." },
      "body": { "fr": "Autre démarche possible, ou délai à attendre, d'après la source.", "en": "..." },
      "link": { "title": { "fr": "...", "en": "..." }, "url": "https://..." }
    }
  ],
  "contacts": ["france_services", "acces_au_droit"],
  "letters": [],
  "sources": ["..."]
}
```

- `kind` :
  - `redirect` : le questionnaire s'arrête et affiche cet écran (la personne peut revenir modifier sa réponse) ;
  - `warning` : le questionnaire continue ; le message s'affiche en haut de la liste de pièces.
- `contacts` et `letters` : identifiants déclarés dans `help.json` (facultatifs).
- Formulation : jamais "vous n'avez pas droit" ni "vous êtes éligible". On écrit "D'après [source], cette démarche concerne les personnes qui..." et on oriente.

Les étapes (`steps`) peuvent aussi référencer des courriers : champ facultatif `"letters": ["id"]`.

## `help.json` : contacts et modèles de courriers

```json
{
  "sources": [ { "id": "...", "publisher": "...", "title": "...", "url": "https://...", "consulted": "2026-10-29" } ],
  "contacts": [
    {
      "id": "france_services",
      "symbol": "person.2",
      "title": { "fr": "France services", "en": "..." },
      "body": { "fr": "Ce que ce service peut faire pour vous, gratuitement.", "en": "..." },
      "phone": "0806001620",
      "link": { "title": { "fr": "Trouver un point près de chez vous", "en": "..." }, "url": "https://..." },
      "sources": ["..."]
    }
  ],
  "letters": [
    {
      "id": "appointment_request",
      "channel": "email",
      "title": { "fr": "Demander un rendez-vous à la préfecture", "en": "..." },
      "purpose": { "fr": "Quand l'utiliser, en une ou deux phrases.", "en": "..." },
      "subject": "Demande de rendez-vous : {{procedure}}",
      "body": "Madame, Monsieur,\n\nJe soussigné(e) {{full_name}}, né(e) le {{birth_date}}...\n\n{{city}}, le {{today}}\n{{full_name}}",
      "summary": { "fr": "Ce que dit ce courrier, en clair, pour qui ne lit pas bien le français.", "en": "..." },
      "fields": ["full_name", "birth_date", "nationality", "foreigner_number", "address", "phone", "email"],
      "attachments": { "fr": "Pièces à joindre, d'après la source.", "en": "..." },
      "sources": ["..."]
    }
  ]
}
```

- `channel` : `email` ou `registered_mail` (lettre recommandée avec avis de réception).
- `subject` et `body` sont **en français uniquement** (ils sont adressés à l'administration). `summary` explique le contenu dans la langue de la personne.
- Champs disponibles dans `{{ }}` : `full_name`, `birth_date`, `birth_place`, `nationality`, `foreigner_number`, `address`, `phone`, `email`, `city`, `prefecture`, `procedure`, `today`. `fields` liste ceux que la personne doit remplir (`city`, `today`, `procedure` et `prefecture` sont remplis par l'app ou demandés à part).
- Un courrier ne fait que demander ou informer ; il ne cite un texte de loi que si une source le cite.


## `guides` : fiches pratiques "Comment l'obtenir ?"

Tableau dans `help.json`. Une fiche explique concrètement comment obtenir une pièce ou faire une action : où aller, en ligne ou sur place, combien ça coûte si la source le dit, combien de temps, pièges à éviter.

```json
{
  "id": "ephoto",
  "symbol": "camera",
  "title": { "fr": "Faire une e-photo (photo d'identité numérique)", "en": "..." },
  "summary": { "fr": "Une phrase : ce que c'est et pourquoi on vous la demande.", "en": "..." },
  "steps": [
    { "fr": "Étape 1, courte et concrète.", "en": "..." },
    { "fr": "Étape 2.", "en": "..." }
  ],
  "cost": { "fr": "Prix, seulement si une source le donne.", "en": "..." },
  "tip": { "fr": "Piège fréquent ou astuce tirée d'une source.", "en": "..." },
  "links": [ { "title": { "fr": "Trouver une cabine ou un photographe agréé", "en": "..." }, "url": "https://..." } ],
  "sources": ["..."]
}
```

`cost`, `tip` et `links` sont facultatifs. Les pièces (`documents`) et les étapes (`steps`) des démarches référencent les fiches par un champ facultatif `"guides": ["ephoto", "fiscal_stamp"]`.

Identifiants de fiches prévus : `ephoto`, `fiscal_stamp`, `sworn_translation`, `legalisation_apostille`, `proof_of_address`, `anef_account`, `prefecture_appointment`, `civil_status_france`, `tax_documents`, `criminal_record`, `language_certificate`, `civic_exam`, `loss_theft_report`, `health_insurance`.

Domaines autorisés supplémentaires pour les fiches : `ants.gouv.fr`, `impots.gouv.fr`, `timbres.impots.gouv.fr`, `ameli.fr`, `france-education-international.fr`, `diplomatie.gouv.fr`, `justice.fr`, `cours-appel.justice.fr`, `casier-judiciaire.justice.gouv.fr`, `courdecassation.fr` (liste des traducteurs agréés), `cci-paris-idf.fr` (inscription au TEF), ces deux derniers parce que service-public y renvoie.

## Catégories du catalogue

`catalog.json` contient un tableau `categories` ; chaque démarche a `category` et `subcategory`.

```json
"categories": [
  {
    "id": "residence",
    "symbol": "person.text.rectangle",
    "title": { "fr": "Séjour", "en": "Residence" },
    "subtitle": { "fr": "Titres de séjour et famille", "en": "..." },
    "subcategories": [ { "id": "permits", "title": { "fr": "Titres de séjour", "en": "Residence permits" } } ]
  }
]
```

## `news.json` : actualités

```json
{
  "lastUpdated": "2026-10-29",
  "items": [
    {
      "id": "taxes_may_2026",
      "date": "2026-05-01",
      "category": "residence",
      "title": { "fr": "Titre court", "en": "..." },
      "summary": { "fr": "Deux ou trois phrases : ce qui change, pour qui, à partir de quand.", "en": "..." },
      "link": { "title": { "fr": "Lire sur service-public.gouv.fr", "en": "..." }, "url": "https://..." },
      "procedures": ["renewal", "naturalisation"]
    }
  ]
}
```

- `date` : date de publication ou d'entrée en vigueur indiquée par la source.
- `category` : un identifiant de `catalog.json` > `categories`, ou `rights`.
- `procedures` : démarches liées (facultatif), pour le bouton "Voir la démarche".
- Le lien doit être sur un domaine autorisé. Pas d'article de presse : seulement des actualités publiées par l'administration.

## Droits : "1 étranger 1 solution"

`rights.json` contient les questions de profil (communes) et la liste des fichiers de droits :

```json
{
  "lastVerified": "2026-10-29",
  "questions": [ ... mêmes champs que les questions des démarches, `sources` peut être vide ... ],
  "parts": ["rights_health_money", "rights_life"]
}
```

Chaque fichier `rights_<partie>.json` :

```json
{
  "sources": [ ... ],
  "rights": [
    {
      "id": "apl",
      "category": "housing",
      "title": { "fr": "Aide personnalisée au logement (APL)", "en": "..." },
      "summary": { "fr": "Une phrase : ce que c'est.", "en": "..." },
      "who": { "fr": "À qui ça s'adresse, d'après la source.", "en": "..." },
      "conditions": [ { "fr": "Condition principale, citée ou reformulée fidèlement.", "en": "..." } ],
      "howTo": [ { "fr": "Étape concrète pour faire la demande.", "en": "..." } ],
      "links": [ { "title": { "fr": "Faire une simulation", "en": "..." }, "url": "https://..." } ],
      "contacts": ["france_services"],
      "guides": ["proof_of_address"],
      "condition": { "question": "residence_status", "in": ["permit", "refugee"] },
      "sources": ["..."]
    }
  ]
}
```

- `category` : `health`, `housing`, `work`, `money`, `bank`, `family`, `justice`.
- `condition` porte sur les questions de profil de `rights.json` ; elle sert à n'afficher que les droits qui **peuvent** concerner la personne. On n'affirme jamais "vous y avez droit" : on écrit "Vous pourriez y avoir droit" et on renvoie vers le simulateur ou l'organisme.
- Domaines autorisés supplémentaires : `caf.fr`, `msa.fr`, `ameli.fr`, `francetravail.fr`, `banque-france.fr`, `education.gouv.fr`, `visale.fr`, `actionlogement.fr`, `mesdroitssociaux.gouv.fr`, `1jeune1solution.gouv.fr`.

## S'expatrier : fiches pays

Catégorie `expatriation` dans `catalog.json`, avec `"showsCountries": true` : son écran propose, en plus de ses démarches, le choix d'un pays.

`countries.json` (tous les pays, liens vérifiés) :

```json
{
  "lastVerified": "2026-10-29",
  "sources": [ ... ],
  "countries": [
    {
      "id": "CA",
      "flag": "🇨🇦",
      "region": "americas",
      "name": { "fr": "Canada", "en": "Canada" },
      "links": [
        { "title": { "fr": "Conseils aux voyageurs : Canada", "en": "..." }, "url": "https://www.diplomatie.gouv.fr/..." },
        { "title": { "fr": "Ambassade et consulats de France au Canada", "en": "..." }, "url": "https://..." },
        { "title": { "fr": "Protection sociale au Canada (Cleiss)", "en": "..." }, "url": "https://www.cleiss.fr/..." }
      ]
    }
  ]
}
```

- `region` : `europe`, `africa`, `americas`, `asia`, `middle_east`, `oceania`.
- `countries_details.json` : informations détaillées pour les pays les plus fréquents, par identifiant de pays :

```json
{
  "lastVerified": "2026-10-29",
  "sources": [ ... ],
  "details": [
    {
      "country": "CA",
      "highlights": [
        { "title": { "fr": "Entrée et séjour", "en": "..." }, "body": { "fr": "...", "en": "..." }, "sources": ["..."] }
      ]
    }
  ]
}
```

Thèmes de `highlights`, seulement si une source les traite : entrée et visas pour un Français, travail, protection sociale (convention ou non, d'après le Cleiss), impôts (convention fiscale, d'après impots.gouv.fr), santé, scolarité (lycées français, AEFE), sécurité, nombre de Français inscrits (registre), contacts utiles.

Domaines autorisés supplémentaires : `cleiss.fr`, `cfe.fr`, `aefe.fr`, `civiweb.com`, `businessfrance.fr`, `info-retraite.fr`, `assemblee-afe.fr`.

### Motifs de départ (fiches détaillées)

Dans `countries_details.json`, chaque pays détaillé peut avoir un tableau `motives` :

```json
"motives": [
  {
    "id": "study",
    "conditions": [ { "fr": "Condition, d'après la source.", "en": "..." } ],
    "age": { "fr": "Règle d'âge s'il y en a une (ex. 18 à 35 ans).", "en": "..." },
    "forms": [ { "title": { "fr": "Formulaire de demande de visa étudiant", "en": "..." }, "url": "https://..." } ],
    "costs": [ { "fr": "Frais de visa : 150 CAD (page consultée le ...)", "en": "..." } ],
    "sources": ["..."]
  }
]
```

`id` : `tourism`, `study`, `work`, `invest`, `retire`, `working_holiday` (programme vacances-travail).

### `countries_budget.json` : budget repère et conversion

```json
{
  "lastVerified": "2026-10-29",
  "sources": [ ... ],
  "rates": { "date": "2026-10-01", "source": "id_source", "perEuro": { "BDT": 130.25, "USD": 1.08 } },
  "perDiem": [ { "country": "BD", "amount": 150, "currency": "EUR", "source": "id_source" } ],
  "workingHoliday": [ { "country": "CA", "minAge": 18, "maxAge": 35, "source": "id_source" } ]
}
```

- `perDiem` : montant journalier du barème de l'État pour les frais de mission à l'étranger (hébergement et repas), par pays, dans la devise du barème. L'app s'en sert comme **repère** : budget = montant journalier x nombre de jours, affiché en euros et dans la monnaie du pays, avec la date du taux. Jamais présenté comme un prix exact.
- `rates.perEuro` : nombre d'unités de chaque devise pour 1 euro, d'une source publique datée (taux de chancellerie de la DGFiP ou taux de référence de la Banque de France / BCE).
- `currencyOf` facultatif : `{ "BD": "BDT" }`, devise locale de chaque pays, si la source la donne.
- `workingHoliday` : pays ayant un accord de programme vacances-travail avec la France et limites d'âge, d'après diplomatie.gouv.fr.

## `appointments` : prendre rendez-vous une fois le dossier prêt

Tableau facultatif dans chaque `procedures/<id>.json`. L'app l'affiche quand toutes les pièces sont cochées (et à tout moment dans l'onglet Étapes).

```json
"appointments": [
  {
    "id": "prefecture_appointment",
    "where": "prefecture",
    "title": { "fr": "Prendre rendez-vous à votre préfecture", "en": "..." },
    "body": { "fr": "Ce qu'il faut savoir : quand, comment, quoi apporter le jour J.", "en": "..." },
    "link": { "title": { "fr": "...", "en": "..." }, "url": "https://..." },
    "condition": null,
    "sources": ["..."]
  }
]
```

`where` : `prefecture` (préfecture ou sous-préfecture du département de la personne : l'app affiche alors sa préfecture et son lien de rendez-vous), `mairie`, `online` (dépôt en ligne, pas de rendez-vous), `ofii`, `tax_office`, `consulate`, `other`.

## `prefectures.json` : préfectures par département

```json
{
  "lastVerified": "2026-10-29",
  "sources": [ ... ],
  "departments": [
    {
      "code": "94",
      "name": "Val-de-Marne",
      "prefecture": { "fr": "Préfecture du Val-de-Marne", "en": "Val-de-Marne prefecture" },
      "city": "Créteil",
      "address": "21-29 avenue du Général de Gaulle, 94000 Créteil",
      "phone": "0149564000",
      "website": "https://www.val-de-marne.gouv.fr",
      "appointmentUrl": "https://www.val-de-marne.gouv.fr/...",
      "subprefecturesUrl": "https://lannuaire.service-public.gouv.fr/...",
      "sources": ["..."]
    }
  ]
}
```

`appointmentUrl` : page "Prendre rendez-vous" ou "Démarches étrangers" du site de la préfecture, seulement si elle a été trouvée et vérifiée ; sinon absent (l'app renvoie au site). Paris : préfecture de police.

### Question `country`

`"kind": "country"` : la personne choisit un pays dans la liste de `countries.json` (recherche par nom). La réponse est le code ISO du pays (ex. `"CA"`). La liste de pièces affiche alors une carte "Votre destination" (budget repère, lien vers la fiche pays). Pas de `condition` sur la valeur d'une question `country`.
