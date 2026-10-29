import SwiftUI

/// Libellés, icônes et ordre d'affichage des catégories de pièces.
enum DocumentCategory {
    static let order = [
        "identity", "civil_status", "residence", "address", "photo", "resources",
        "work", "studies", "family", "integration", "tax", "other",
    ]

    static func title(_ id: String) -> LocalizedStringKey {
        switch id {
        case "identity": "Identité"
        case "civil_status": "État civil"
        case "residence": "Séjour"
        case "address": "Domicile"
        case "photo": "Photo et signature"
        case "resources": "Ressources"
        case "work": "Travail"
        case "studies": "Études"
        case "family": "Famille"
        case "integration": "Langue et intégration"
        case "tax": "Impôts et taxes"
        default: "Autres pièces"
        }
    }

    static func symbol(_ id: String) -> String {
        switch id {
        case "identity": "person.text.rectangle"
        case "civil_status": "doc.text"
        case "residence": "creditcard"
        case "address": "house"
        case "photo": "camera"
        case "resources": "eurosign.circle"
        case "work": "briefcase"
        case "studies": "graduationcap"
        case "family": "figure.2.and.child.holdinghands"
        case "integration": "text.bubble"
        case "tax": "building.columns"
        default: "folder"
        }
    }

    /// Regroupe les pièces par catégorie, dans l'ordre ci-dessus.
    static func group(_ documents: [RequiredDocument]) -> [(category: String, documents: [RequiredDocument])] {
        let grouped = Dictionary(grouping: documents) { order.contains($0.category) ? $0.category : "other" }
        return order.compactMap { id in grouped[id].map { (id, $0) } }
    }
}
