import Foundation

/// Préfecture de chaque département (`prefectures.json`).
struct PrefectureDirectory: Decodable {
    let lastVerified: String
    let sources: [Source]
    let departments: [Department]

    func department(code: String) -> Department? {
        departments.first { $0.code == code }
    }

    func sources(for ids: [String]) -> [Source] {
        ids.compactMap { id in sources.first { $0.id == id } }
    }
}

struct Department: Decodable, Identifiable, Hashable {
    let code: String
    let name: String
    let prefecture: LocalizedText
    let city: String?
    let address: String?
    let phone: String?
    let website: URL?
    let appointmentUrl: URL?
    let subprefecturesUrl: URL?
    let sources: [String]

    var id: String { code }
}
