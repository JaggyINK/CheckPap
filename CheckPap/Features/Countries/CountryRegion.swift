import SwiftUI

/// Libellés et ordre des grandes régions du monde.
enum CountryRegion {
    static let order = ["europe", "africa", "americas", "asia", "middle_east", "oceania"]

    static func title(_ id: String) -> LocalizedStringKey {
        switch id {
        case "europe": "Europe"
        case "africa": "Afrique"
        case "americas": "Amériques"
        case "asia": "Asie"
        case "middle_east": "Moyen-Orient"
        case "oceania": "Océanie"
        default: "Autres pays"
        }
    }
}
