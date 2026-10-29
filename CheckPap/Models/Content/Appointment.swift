import Foundation

/// Où et comment déposer le dossier ou prendre rendez-vous, une fois les pièces prêtes.
struct Appointment: Decodable, Identifiable, Hashable {
    enum Place: String, Decodable {
        case prefecture, mairie, online, ofii, taxOffice = "tax_office", consulate, other
    }

    let id: String
    let `where`: Place
    let title: LocalizedText
    let body: LocalizedText
    let link: StepLink?
    let condition: Condition?
    let sources: [String]
}
