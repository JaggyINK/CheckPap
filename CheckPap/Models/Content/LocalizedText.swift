import SwiftUI

/// Texte traduit venant du JSON : `{ "fr": "...", "en": "..." }`.
/// Ajouter une langue = ajouter une clé dans le JSON, sans toucher au code.
struct LocalizedText: Decodable, Hashable {
    let values: [String: String]

    init(_ values: [String: String]) {
        self.values = values
    }

    init(from decoder: Decoder) throws {
        values = try decoder.singleValueContainer().decode([String: String].self)
    }

    /// Texte dans la langue demandée, avec repli sur le français.
    func resolved(_ locale: Locale) -> String {
        let code = locale.language.languageCode?.identifier ?? "fr"
        return values[code] ?? values["fr"] ?? values.values.first ?? ""
    }
}

/// Affiche un `LocalizedText` dans la langue de l'environnement SwiftUI.
/// S'utilise comme `Text` : `ContentText(question.title).font(.title2)`.
struct ContentText: View {
    let text: LocalizedText
    @Environment(\.locale) private var locale

    init(_ text: LocalizedText) {
        self.text = text
    }

    var body: some View {
        Text(verbatim: text.resolved(locale))
    }
}
