import SwiftUI

/// Champs que la personne peut remplir dans un courrier.
enum LetterField: String, CaseIterable {
    case fullName = "full_name"
    case birthDate = "birth_date"
    case birthPlace = "birth_place"
    case nationality
    case foreignerNumber = "foreigner_number"
    case address
    case city
    case phone
    case email
    case prefecture
    case depositDate = "deposit_date"
    case fileNumber = "file_number"

    var label: LocalizedStringKey {
        switch self {
        case .fullName: "Nom et prénom"
        case .birthDate: "Date de naissance"
        case .birthPlace: "Lieu de naissance"
        case .nationality: "Nationalité"
        case .foreignerNumber: "Numéro étranger"
        case .address: "Adresse"
        case .city: "Ville"
        case .phone: "Téléphone"
        case .email: "E-mail"
        case .prefecture: "Préfecture"
        case .depositDate: "Date de dépôt"
        case .fileNumber: "Numéro de dossier"
        }
    }

    var prompt: LocalizedStringKey {
        switch self {
        case .fullName: "Ex. : Amina DIALLO"
        case .birthDate: "Ex. : 12 mars 1998"
        case .birthPlace: "Ex. : Dakar (Sénégal)"
        case .nationality: "Ex. : sénégalaise"
        case .foreignerNumber: "Indiqué sur votre titre de séjour"
        case .address: "Numéro, rue, code postal, ville"
        case .city: "Ex. : Créteil"
        case .phone: "Ex. : 06 12 34 56 78"
        case .email: "Ex. : prenom.nom@exemple.fr"
        case .prefecture: "Ex. : Préfecture du Val-de-Marne"
        case .depositDate: "Ex. : 3 septembre 2026"
        case .fileNumber: "Indiqué sur votre attestation de dépôt"
        }
    }

    var keyboard: UIKeyboardType {
        switch self {
        case .phone: .phonePad
        case .email: .emailAddress
        default: .default
        }
    }

    /// Champs à afficher pour un modèle : ceux qu'il déclare, plus ville et préfecture s'il les utilise.
    static func fields(for letter: LetterTemplate) -> [LetterField] {
        let text = letter.subject + letter.body
        return allCases.filter { field in
            letter.fields.contains(field.rawValue) || text.contains("{{\(field.rawValue)}}")
        }
    }
}
