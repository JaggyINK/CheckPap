import Foundation

/// Réponses du profil "Mes droits", gardées uniquement sur ce téléphone.
enum RightsProfileStore {
    private static let key = "rightsProfileAnswers"

    static func load() -> [String: String] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let answers = try? JSONDecoder().decode([String: String].self, from: data)
        else { return [:] }
        return answers
    }

    static func save(_ answers: [String: String]) {
        if let data = try? JSONEncoder().encode(answers) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
