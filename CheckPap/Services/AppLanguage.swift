import SwiftUI

/// Langue de l'app : celle du téléphone par défaut, ou une langue choisie dans l'app.
/// Ajouter une langue : un cas ici, la langue dans le String Catalog et dans le projet,
/// puis (facultatif) la clé dans les JSON de contenu.
enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case fr, en
    case ar, bn, hi, zhHans = "zh-Hans", ru, id, th, tr
    case uk, fa, ps, ur, ta, ti, pt, es

    static let storageKey = "appLanguage"

    var id: String { rawValue }

    /// Locale à appliquer à l'app ; `nil` = celle du téléphone.
    var locale: Locale? {
        self == .system ? nil : Locale(identifier: rawValue)
    }

    /// Nom de la langue écrit dans cette langue, pour qu'on la reconnaisse sans lire le français.
    var nativeName: String {
        switch self {
        case .system: String(localized: "Langue du téléphone")
        case .fr: "Français"
        case .en: "English"
        case .ar: "العربية"
        case .bn: "বাংলা"
        case .hi: "हिन्दी"
        case .zhHans: "中文（简体）"
        case .ru: "Русский"
        case .id: "Bahasa Indonesia"
        case .th: "ไทย"
        case .tr: "Türkçe"
        case .uk: "Українська"
        case .fa: "دری / فارسی"
        case .ps: "پښتو"
        case .ur: "اردو"
        case .ta: "தமிழ்"
        case .ti: "ትግርኛ"
        case .pt: "Português"
        case .es: "Español"
        }
    }

    /// Nom en français, affiché en petit sous le nom natif.
    var frenchName: String? {
        switch self {
        case .system, .fr: nil
        case .en: "Anglais"
        case .ar: "Arabe"
        case .bn: "Bengali"
        case .hi: "Hindi"
        case .zhHans: "Chinois simplifié"
        case .ru: "Russe"
        case .id: "Indonésien"
        case .th: "Thaï"
        case .tr: "Turc"
        case .uk: "Ukrainien"
        case .fa: "Dari (persan d'Afghanistan)"
        case .ps: "Pachto"
        case .ur: "Ourdou"
        case .ta: "Tamoul"
        case .ti: "Tigrigna"
        case .pt: "Portugais"
        case .es: "Espagnol"
        }
    }

    /// Langues écrites de droite à gauche.
    static func isRightToLeft(_ locale: Locale) -> Bool {
        guard let code = locale.language.languageCode?.identifier else { return false }
        return ["ar", "fa", "ps", "ur", "he"].contains(code)
    }
}
