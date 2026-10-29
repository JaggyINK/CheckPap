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

    /// Texte dans la langue demandée. Si le contenu n'est pas encore traduit dans cette langue :
    /// anglais pour les langues autres que le français, puis français.
    func resolved(_ locale: Locale) -> String {
        let language = locale.language
        let code = language.languageCode?.identifier ?? "fr"
        let script = language.script.map { "\(code)-\($0.identifier)" }
        return script.flatMap { values[$0] } ?? values[code]
            ?? (code == "fr" ? nil : values["en"]) ?? values["fr"] ?? values.values.first ?? ""
    }

    func isAvailable(in locale: Locale) -> Bool {
        let language = locale.language
        let code = language.languageCode?.identifier ?? "fr"
        let script = language.script.map { "\(code)-\($0.identifier)" }
        return script.map { values[$0] != nil } == true || values[code] != nil
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
