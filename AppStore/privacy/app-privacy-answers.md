# Réponses aux questionnaires d'App Store Connect

## Confidentialité de l'app (App Privacy)

- **"Collectez-vous des données depuis cette app ?"** : **Non, nous ne collectons pas de données depuis cette app.**
- Justification : toutes les informations restent sur l'appareil (SwiftData et UserDefaults) ; l'app ne fait aucun appel réseau vers un serveur de Check Pap ou d'un tiers ; aucun SDK d'analyse, de publicité ou de crash reporting tiers. Les rapports de plantage d'Apple (partagés par les utilisateurs qui l'ont accepté) ne comptent pas comme une collecte par l'app.
- Étiquette affichée sur la fiche : **"Aucune donnée collectée"**.
- URL de la politique : adresse de `site/confidentialite.html` une fois publiée.

À revoir si un jour : chargement du contenu depuis un serveur, compte utilisateur, statistiques, notifications push.

## Classification par âge

Répondre "Aucun" ou "Non" à toutes les rubriques (violence, contenu sexuel, langage grossier, drogues, jeux d'argent, horreur, etc.) :

- Accès web non restreint : **Non** (les liens ouvrent Safari, l'app n'intègre pas de navigateur).
- Contenu généré par les utilisateurs : **Non**.
- Messagerie ou chat : **Non**.
- Publicité : **Non**.
- Informations médicales ou de santé : **Non** (l'app décrit des droits à l'assurance maladie, sans conseil médical).

Résultat attendu : **4+** (ou la tranche minimale proposée).

## Conformité à l'exportation (chiffrement)

Déjà déclaré dans l'app : `ITSAppUsesNonExemptEncryption = NO` (seul le chiffrement standard d'iOS est utilisé). Aucune question à chaque envoi.

## Droits sur le contenu

"L'app contient-elle du contenu de tiers ?" : **Non**, le contenu est rédigé pour l'app à partir d'informations publiques, avec la source citée pour chaque élément.
