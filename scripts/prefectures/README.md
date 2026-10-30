# Vérifier les sites et pages de rendez-vous des préfectures

`CheckPap/Resources/Content/prefectures.json` est généré à partir de l'annuaire de l'administration (adresses, téléphones, sous-préfectures) et d'une vérification des sites des préfectures (site web et page "Prendre un rendez-vous" ou "Étrangers").

État au 30/10/2026 : sites vérifiés pour 01 à 48, 2A, 2B et Paris ; pages de rendez-vous pour 01 à 19, 21 à 23 et Paris. Les sites des préfectures bloquent les vérifications trop rapprochées : il faut avancer lentement, sur plusieurs jours si besoin, sans jamais contourner un blocage.

```bash
cd scripts/prefectures
DELAY=3 python3 -I crawl2.py data          # reprend là où il s'est arrêté (une requête toutes les 3 s)
python3 -I generate.py data ../../CheckPap/Resources/Content/prefectures.json
cd ../.. && ./scripts/check_content.sh
```

Après un passage : relire `data/manual_checks.json` (choix à valider) et mettre à jour les `reviewNotes` du fichier généré.
