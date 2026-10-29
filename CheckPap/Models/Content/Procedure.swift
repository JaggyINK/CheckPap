import Foundation

/// Liste des démarches disponibles et leur rangement (`catalog.json`).
struct Catalog: Decodable {
    let schemaVersion: Int
    let contentVersion: String
    let categories: [ProcedureCategory]?
    let procedures: [CatalogEntry]
}

struct CatalogEntry: Decodable, Identifiable, Hashable {
    let id: String
    let symbol: String
    let title: LocalizedText
    let subtitle: LocalizedText
    let category: String?
    let subcategory: String?
    /// `true` pour proposer le choix d'un pays depuis la démarche (ex. : voyager hors de France).
    let showsCountries: Bool?
}

/// Grande famille de démarches (Séjour, Nationalité...), découpée en sous-catégories.
struct ProcedureCategory: Decodable, Identifiable, Hashable {
    let id: String
    let symbol: String
    let title: LocalizedText
    let subtitle: LocalizedText
    let subcategories: [Subcategory]
    /// `true` pour "S'expatrier" : l'écran propose aussi le choix d'un pays.
    let showsCountries: Bool?
}

struct Subcategory: Decodable, Identifiable, Hashable {
    let id: String
    let title: LocalizedText
}

/// Une démarche complète (`procedures/<id>.json`).
struct Procedure: Decodable, Identifiable {
    let id: String
    let reviewStatus: String
    let lastVerified: String
    let title: LocalizedText
    let summary: LocalizedText
    let sources: [Source]
    let questions: [Question]
    let documents: [RequiredDocument]
    let steps: [GuideStep]
    let deadlines: [Deadline]?
    let outcomes: [Outcome]?
    let reviewNotes: [String]?

    var isDraft: Bool { reviewStatus != "verified" }

    func sources(for ids: [String]) -> [Source] {
        ids.compactMap { id in sources.first { $0.id == id } }
    }
}

struct Source: Decodable, Identifiable, Hashable {
    let id: String
    let publisher: String
    let title: String
    let url: URL
    let consulted: String
}

struct Question: Decodable, Identifiable, Hashable {
    enum Kind: String, Decodable {
        case single, yesNo, date
    }

    let id: String
    let kind: Kind
    let title: LocalizedText
    let help: LocalizedText?
    let example: LocalizedText?
    let options: [AnswerOption]?
    let condition: Condition?
    let sources: [String]

    /// Choix proposés : ceux du JSON, ou Oui / Non pour une question `yesNo`.
    var choices: [AnswerOption] {
        switch kind {
        case .single: options ?? []
        case .yesNo: [AnswerOption.yes, AnswerOption.no]
        case .date: []
        }
    }
}

struct AnswerOption: Decodable, Identifiable, Hashable {
    let id: String
    let label: LocalizedText
    let help: LocalizedText?

    static let yes = AnswerOption(id: "yes", label: LocalizedText(["fr": "Oui", "en": "Yes"]), help: nil)
    static let no = AnswerOption(id: "no", label: LocalizedText(["fr": "Non", "en": "No"]), help: nil)
}

struct RequiredDocument: Decodable, Identifiable, Hashable {
    let id: String
    let category: String
    let title: LocalizedText
    let details: LocalizedText?
    let example: LocalizedText?
    let tip: LocalizedText?
    let guides: [String]?
    let condition: Condition?
    let sources: [String]
}

struct GuideStep: Decodable, Identifiable, Hashable {
    enum Phase: String, Decodable, CaseIterable {
        case before, submit, after
    }

    let id: String
    let phase: Phase
    let title: LocalizedText
    let body: LocalizedText
    let link: StepLink?
    let letters: [String]?
    let guides: [String]?
    let condition: Condition?
    let sources: [String]
}

struct StepLink: Decodable, Hashable {
    let title: LocalizedText
    let url: URL
}

struct Deadline: Decodable, Identifiable, Hashable {
    let id: String
    let relativeTo: String
    let offsetDays: Int
    let title: LocalizedText
    let condition: Condition?
    let sources: [String]
}

/// Dates du contenu au format `AAAA-MM-JJ`.
enum DayDate {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func parse(_ string: String) -> Date? {
        formatter.date(from: string)
    }

    static func format(_ date: Date) -> String {
        formatter.string(from: date)
    }
}
