import Foundation

/// Tous les pays, avec leurs liens utiles (`countries.json`).
struct CountryList: Decodable {
    let lastVerified: String
    let sources: [Source]
    let countries: [Country]
}

struct Country: Decodable, Identifiable, Hashable {
    let id: String
    let flag: String
    let region: String
    let name: LocalizedText
    let links: [StepLink]
}

/// Informations détaillées pour les pays où partent le plus de Français (`countries_details.json`).
struct CountryDetailsFile: Decodable {
    let lastVerified: String
    let sources: [Source]
    let details: [CountryDetails]
}

struct CountryDetails: Decodable, Hashable {
    let country: String
    let highlights: [CountryHighlight]
}

struct CountryHighlight: Decodable, Hashable {
    let title: LocalizedText
    let body: LocalizedText
    let sources: [String]
}

/// Liste et fiches réunies, prêtes à être affichées.
struct CountriesContent {
    let list: CountryList
    let details: CountryDetailsFile?

    func country(id: String) -> Country? {
        list.countries.first { $0.id == id }
    }

    func highlights(for id: String) -> [CountryHighlight] {
        details?.details.first { $0.country == id }?.highlights ?? []
    }

    func hasDetails(_ id: String) -> Bool {
        !highlights(for: id).isEmpty
    }

    func sources(for ids: [String]) -> [Source] {
        let all = list.sources + (details?.sources ?? [])
        return ids.compactMap { id in all.first { $0.id == id } }
    }
}
