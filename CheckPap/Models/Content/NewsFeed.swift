import Foundation

/// Actualités publiées par l'administration (`news.json`).
struct NewsFeed: Decodable {
    let lastUpdated: String
    let items: [NewsItem]
}

struct NewsItem: Decodable, Identifiable, Hashable {
    let id: String
    let date: String
    let category: String
    let title: LocalizedText
    let summary: LocalizedText
    let link: StepLink
    let procedures: [String]?
}
