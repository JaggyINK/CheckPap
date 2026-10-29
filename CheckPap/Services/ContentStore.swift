import Foundation
import Observation

/// Contenu chargé une fois au démarrage et partagé avec toutes les vues (via `.environment`).
@Observable
final class ContentStore {
    enum State {
        case loading
        case loaded
        case failed(String)
    }

    private(set) var state: State = .loading
    private(set) var catalog: Catalog?
    private(set) var procedures: [String: Procedure] = [:]
    /// Contacts et courriers ; `nil` si `help.json` est absent ou invalide.
    private(set) var help: HelpContent?
    private(set) var news: NewsFeed?
    private(set) var rights: RightsContent?
    private(set) var countries: CountriesContent?

    private let repository: ContentRepository

    init(repository: ContentRepository) {
        self.repository = repository
    }

    /// Démarches du catalogue dont le fichier a bien été chargé.
    var availableEntries: [CatalogEntry] {
        catalog?.procedures.filter { procedures[$0.id] != nil } ?? []
    }

    var contentVersion: String {
        catalog?.contentVersion ?? ""
    }

    /// Démarches d'une catégorie et d'une sous-catégorie, dans l'ordre du catalogue.
    func entries(category: String, subcategory: String) -> [CatalogEntry] {
        availableEntries.filter { $0.category == category && $0.subcategory == subcategory }
    }

    /// Catégories qui contiennent au moins une démarche disponible.
    var availableCategories: [ProcedureCategory] {
        (catalog?.categories ?? []).filter { category in
            availableEntries.contains { $0.category == category.id }
                || (category.showsCountries == true && countries != nil)
        }
    }

    func entry(id: String) -> CatalogEntry? {
        availableEntries.first { $0.id == id }
    }

    /// Les contenus secondaires (actualités, droits...) ne bloquent jamais l'app s'ils manquent.
    private func loadOptional<T>(_ name: String, _ load: () async throws -> T) async -> T? {
        do {
            return try await load()
        } catch {
            print("Contenu indisponible (\(name)) : \(error)")
            return nil
        }
    }

    func load() async {
        do {
            let catalog = try await repository.loadCatalog()
            var loaded: [String: Procedure] = [:]
            for entry in catalog.procedures {
                do {
                    loaded[entry.id] = try await repository.loadProcedure(id: entry.id)
                } catch {
                    // Une démarche invalide ne bloque pas les autres.
                    print("Contenu ignoré pour \(entry.id) : \(error)")
                }
            }
            self.catalog = catalog
            self.procedures = loaded
            help = await loadOptional("contacts et courriers") { try await repository.loadHelp() }
            news = await loadOptional("actualités") { try await repository.loadNews() }
            rights = await loadOptional("droits") { try await repository.loadRights() }
            countries = await loadOptional("pays") { try await repository.loadCountries() }
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
