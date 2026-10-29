import Foundation

/// Source du contenu. Aujourd'hui les fichiers inclus dans l'app ;
/// demain un serveur, sans changer le reste du code.
protocol ContentRepository {
    func loadCatalog() async throws -> Catalog
    func loadProcedure(id: String) async throws -> Procedure
    func loadHelp() async throws -> HelpContent
    func loadNews() async throws -> NewsFeed
    func loadRights() async throws -> RightsContent
    func loadCountries() async throws -> CountriesContent
    func loadPrefectures() async throws -> PrefectureDirectory
}

enum ContentError: LocalizedError {
    case missingFile(String)

    var errorDescription: String? {
        switch self {
        case let .missingFile(name): "Fichier de contenu introuvable : \(name).json"
        }
    }
}

/// Lit les fichiers JSON copiés dans l'app (dossier `Resources/Content`).
struct BundleContentRepository: ContentRepository {
    var bundle: Bundle = .main

    func loadCatalog() async throws -> Catalog {
        try decode(Catalog.self, file: "catalog")
    }

    func loadProcedure(id: String) async throws -> Procedure {
        try decode(Procedure.self, file: id)
    }

    func loadHelp() async throws -> HelpContent {
        try decode(HelpContent.self, file: "help")
    }

    func loadNews() async throws -> NewsFeed {
        try decode(NewsFeed.self, file: "news")
    }

    func loadPrefectures() async throws -> PrefectureDirectory {
        try decode(PrefectureDirectory.self, file: "prefectures")
    }

    /// La liste de tous les pays, complétée par les fiches détaillées si elles existent.
    func loadCountries() async throws -> CountriesContent {
        let list = try decode(CountryList.self, file: "countries")
        let details = try? decode(CountryDetailsFile.self, file: "countries_details")
        let budget = try? decode(CountryBudgetFile.self, file: "countries_budget")
        return CountriesContent(list: list, details: details, budget: budget)
    }

    /// Le profil, puis chaque fichier de droits qu'il annonce. Un fichier absent est ignoré.
    func loadRights() async throws -> RightsContent {
        let profile = try decode(RightsProfile.self, file: "rights")
        let parts = profile.parts.compactMap { try? decode(RightsPart.self, file: $0) }
        return RightsContent(
            profile: profile,
            rights: parts.flatMap(\.rights),
            sources: parts.flatMap(\.sources)
        )
    }

    private func decode<T: Decodable>(_ type: T.Type, file: String) throws -> T {
        guard let url = bundle.url(forResource: file, withExtension: "json") else {
            throw ContentError.missingFile(file)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }
}
