import Foundation

/// Orientation affichée quand des réponses montrent, d'après une source,
/// que la démarche ne correspond pas à la situation (`redirect`)
/// ou qu'un point demande une attention particulière (`warning`).
struct Outcome: Decodable, Identifiable, Hashable {
    enum Kind: String, Decodable {
        case redirect, warning
    }

    let id: String
    let kind: Kind
    let condition: Condition?
    let title: LocalizedText
    let body: LocalizedText
    let actions: [OutcomeAction]?
    let contacts: [String]?
    let letters: [String]?
    let sources: [String]
}

/// Une piste concrète : autre démarche, délai, lien utile.
struct OutcomeAction: Decodable, Hashable {
    let title: LocalizedText
    let body: LocalizedText?
    let link: StepLink?
}
