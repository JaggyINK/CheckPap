import Foundation

/// Contacts d'aide et modèles de courriers communs à toutes les démarches (`help.json`).
struct HelpContent: Decodable {
    let sources: [Source]
    let contacts: [Contact]
    let letters: [LetterTemplate]
    let guides: [PracticalGuide]?

    func contacts(for ids: [String]?) -> [Contact] {
        (ids ?? []).compactMap { id in contacts.first { $0.id == id } }
    }

    func letters(for ids: [String]?) -> [LetterTemplate] {
        (ids ?? []).compactMap { id in letters.first { $0.id == id } }
    }

    func guides(for ids: [String]?) -> [PracticalGuide] {
        (ids ?? []).compactMap { id in guides?.first { $0.id == id } }
    }

    func sources(for ids: [String]) -> [Source] {
        ids.compactMap { id in sources.first { $0.id == id } }
    }
}

/// Un service qui peut aider (France services, point-justice...).
struct Contact: Decodable, Identifiable, Hashable {
    let id: String
    let symbol: String?
    let title: LocalizedText
    let body: LocalizedText
    let phone: String?
    let link: StepLink?
    let sources: [String]
}

/// Modèle de courrier à compléter. L'objet et le corps sont en français :
/// ils sont adressés à l'administration. `summary` les explique dans la langue de la personne.
struct LetterTemplate: Decodable, Identifiable, Hashable {
    enum Channel: String, Decodable {
        case email
        case registeredMail = "registered_mail"
    }

    let id: String
    let channel: Channel
    let title: LocalizedText
    let purpose: LocalizedText
    let subject: String
    let body: String
    let summary: LocalizedText
    let fields: [String]
    let attachments: LocalizedText?
    let sources: [String]
}

/// Fiche "Comment l'obtenir ?" : où aller, quoi faire, combien ça coûte, liens pour agir.
struct PracticalGuide: Decodable, Identifiable, Hashable {
    let id: String
    let symbol: String?
    let title: LocalizedText
    let summary: LocalizedText
    let steps: [LocalizedText]
    let cost: LocalizedText?
    let tip: LocalizedText?
    let links: [StepLink]?
    let sources: [String]
}
