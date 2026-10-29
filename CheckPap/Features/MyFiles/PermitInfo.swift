import Foundation

/// Le titre de séjour de la personne : date de fin, type (réponses aux questions du renouvellement)
/// et rappels programmés. Gardé uniquement sur ce téléphone.
struct PermitInfo: Codable, Equatable {
    /// Réponses aux questions de `renewal.json` (type de titre, date de fin...).
    var answers: [String: String]
    var notificationIds: [String] = []

    static let procedureId = "renewal"
    static let expiryQuestion = "permit_expiry_date"
    /// Questions de la démarche Renouvellement reprises ici : seulement celles qui changent les délais.
    static let typeQuestions = ["permit_type", "vpf_reason"]
    private static let key = "permitInfo"

    var expiryDate: Date? {
        answers[Self.expiryQuestion].flatMap { DayDate.parse($0) }
    }

    static func load() -> PermitInfo? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(PermitInfo.self, from: data)
    }

    static func save(_ info: PermitInfo?) {
        if let info, let data = try? JSONEncoder().encode(info) {
            UserDefaults.standard.set(data, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
