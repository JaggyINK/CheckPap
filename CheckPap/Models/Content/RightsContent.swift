import Foundation

/// Questions de profil de l'onglet "Mes droits" (`rights.json`).
struct RightsProfile: Decodable {
    let lastVerified: String
    let parts: [String]
    let questions: [Question]
}

/// Un fichier de droits (`rights_<partie>.json`).
struct RightsPart: Decodable {
    let sources: [Source]
    let rights: [RightItem]
}

/// Un droit ou une aide qui peut concerner la personne.
struct RightItem: Decodable, Identifiable, Hashable {
    let id: String
    let category: String
    let title: LocalizedText
    let summary: LocalizedText
    let who: LocalizedText?
    let conditions: [LocalizedText]?
    let howTo: [LocalizedText]?
    let links: [StepLink]?
    let contacts: [String]?
    let guides: [String]?
    let condition: Condition?
    let sources: [String]
}

/// Profil et droits réunis, prêts à être affichés.
struct RightsContent {
    let profile: RightsProfile
    let rights: [RightItem]
    let sources: [Source]

    func sources(for ids: [String]) -> [Source] {
        ids.compactMap { id in sources.first { $0.id == id } }
    }
}
