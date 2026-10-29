import Foundation

/// Remplit un modèle de courrier : chaque `{{champ}}` est remplacé par la valeur saisie.
/// Un champ laissé vide reste visible sous la forme "[à compléter]".
enum LetterRenderer {
    static let placeholder = "[à compléter]"

    static func render(_ template: String, values: [String: String]) -> String {
        var result = template
        for (key, value) in values where !value.trimmingCharacters(in: .whitespaces).isEmpty {
            result = result.replacingOccurrences(of: "{{\(key)}}", with: value)
        }
        return result.replacingOccurrences(
            of: #"\{\{[a-z_]+\}\}"#,
            with: placeholder,
            options: .regularExpression
        )
    }

    /// Date du jour en toutes lettres, en français (le courrier est toujours en français).
    static func today(_ date: Date = .now) -> String {
        date.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "fr_FR")))
    }
}
