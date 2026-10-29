import Foundation

/// Condition déclarative lue dans le JSON (voir docs/content-schema.md).
/// `indirect` : une condition peut contenir d'autres conditions (structure récursive).
indirect enum Condition: Decodable, Hashable {
    case equals(question: String, value: String)
    case oneOf(question: String, values: [String])
    case all([Condition])
    case any([Condition])
    case not(Condition)

    private enum Keys: String, CodingKey {
        case question, equals, `in`, all, any, not
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        if let conditions = try container.decodeIfPresent([Condition].self, forKey: .all) {
            self = .all(conditions)
        } else if let conditions = try container.decodeIfPresent([Condition].self, forKey: .any) {
            self = .any(conditions)
        } else if let condition = try container.decodeIfPresent(Condition.self, forKey: .not) {
            self = .not(condition)
        } else {
            let question = try container.decode(String.self, forKey: .question)
            if let value = try container.decodeIfPresent(String.self, forKey: .equals) {
                self = .equals(question: question, value: value)
            } else if let values = try container.decodeIfPresent([String].self, forKey: .in) {
                self = .oneOf(question: question, values: values)
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .question, in: container,
                    debugDescription: "Condition sans 'equals' ni 'in' pour la question \(question)"
                )
            }
        }
    }

    /// Toutes les paires (question, valeurs attendues) citées, pour les tests de cohérence.
    var references: [(question: String, values: [String])] {
        switch self {
        case let .equals(question, value): [(question, [value])]
        case let .oneOf(question, values): [(question, values)]
        case let .all(conditions), let .any(conditions): conditions.flatMap(\.references)
        case let .not(condition): condition.references
        }
    }
}
