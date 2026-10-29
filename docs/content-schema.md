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
```

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
