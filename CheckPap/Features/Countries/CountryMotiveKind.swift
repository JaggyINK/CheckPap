import SwiftUI

/// Libellés et icônes des motifs de départ.
enum CountryMotiveKind {
    static let order = ["tourism", "study", "work", "invest", "retire", "working_holiday"]

    static func title(_ id: String) -> LocalizedStringKey {
        switch id {
        case "tourism": "Tourisme"
        case "study": "Études"
        case "work": "Travail"
        case "invest": "Investir, créer une entreprise"
        case "retire": "Retraite"
        case "working_holiday": "Vacances-travail (PVT)"
        default: "Autre"
        }
    }

    static func symbol(_ id: String) -> String {
        switch id {
        case "tourism": "camera"
        case "study": "graduationcap"
        case "work": "briefcase"
        case "invest": "chart.line.uptrend.xyaxis"
        case "retire": "sun.max"
        case "working_holiday": "backpack"
        default: "questionmark.circle"
        }
    }
}
