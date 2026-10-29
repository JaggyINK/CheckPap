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
    let motives: [CountryMotive]?
}

/// Ce que le pays demande selon le motif du départ (tourisme, études, travail...).
struct CountryMotive: Decodable, Hashable, Identifiable {
    let id: String
    let conditions: [LocalizedText]?
    let age: LocalizedText?
    let forms: [StepLink]?
    let costs: [LocalizedText]?
    let sources: [String]
}

struct CountryHighlight: Decodable, Hashable {
    let title: LocalizedText
    let body: LocalizedText
    let sources: [String]
}

/// Barème journalier, taux de change et programmes vacances-travail (`countries_budget.json`).
struct CountryBudgetFile: Decodable {
    let lastVerified: String
    let sources: [Source]
    let rates: ExchangeRates
    let perDiem: [PerDiem]
    let currencyOf: [String: String]?
    let workingHoliday: [WorkingHoliday]?
    /// Repère bas : indemnité mensuelle du Volontariat international (VIE / VIA), en euros.
    let vieMonthly: [MonthlyAllowance]?
}

struct MonthlyAllowance: Decodable {
    let country: String
    let amount: Double
    let currency: String
    let source: String
}

struct ExchangeRates: Decodable {
    let date: String
    let source: String
    /// Unités de chaque devise pour 1 euro.
    let perEuro: [String: Double]
}

struct PerDiem: Decodable {
    let country: String
    let amount: Double
    let currency: String
    let source: String
}

struct WorkingHoliday: Decodable {
    let country: String
    let minAge: Int
    let maxAge: Int
    let source: String
}

/// Liste et fiches réunies, prêtes à être affichées.
struct CountriesContent {
    let list: CountryList
    let details: CountryDetailsFile?
    let budget: CountryBudgetFile?

    func motives(for id: String) -> [CountryMotive] {
        details?.details.first { $0.country == id }?.motives ?? []
    }

    func perDiem(for id: String) -> PerDiem? {
        budget?.perDiem.first { $0.country == id }
    }

    func vieMonthly(for id: String) -> MonthlyAllowance? {
        budget?.vieMonthly?.first { $0.country == id }
    }

    func localCurrency(for id: String) -> String? {
        budget?.currencyOf?[id]
    }

    func workingHoliday(for id: String) -> WorkingHoliday? {
        budget?.workingHoliday?.first { $0.country == id }
    }

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
        let all = list.sources + (details?.sources ?? []) + (budget?.sources ?? [])
        return ids.compactMap { id in all.first { $0.id == id } }
    }
}
