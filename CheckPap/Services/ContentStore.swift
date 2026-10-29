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
            do {
                help = try await repository.loadHelp()
            } catch {
                print("Contacts et courriers indisponibles : \(error)")
            }
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
