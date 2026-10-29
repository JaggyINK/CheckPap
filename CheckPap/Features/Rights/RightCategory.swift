import SwiftUI

/// Libellés, icônes et ordre des catégories de droits.
enum RightCategory {
    static let order = ["health", "money", "housing", "work", "family", "bank", "justice"]

    static func title(_ id: String) -> LocalizedStringKey {
        switch id {
        case "health": "Santé"
        case "money": "Argent et aides"
        case "housing": "Logement"
        case "work": "Travail"
        case "family": "Famille et école"
        case "bank": "Banque"
        case "justice": "Recours et justice"
        default: "Autres droits"
        }
    }

    static func symbol(_ id: String) -> String {
        switch id {
        case "health": "cross.case"
        case "money": "eurosign.circle"
        case "housing": "house"
        case "work": "briefcase"
        case "family": "figure.2.and.child.holdinghands"
        case "bank": "building.columns"
        case "justice": "scale.3d"
        default: "hand.raised"
        }
    }

    static func group(_ rights: [RightItem]) -> [(category: String, rights: [RightItem])] {
        let grouped = Dictionary(grouping: rights) { order.contains($0.category) ? $0.category : "other" }
        return (order + ["other"]).compactMap { id in grouped[id].map { (id, $0) } }
    }
}
