import Foundation

/// Source du contenu. Aujourd'hui les fichiers inclus dans l'app ;
/// demain un serveur, sans changer le reste du code.
protocol ContentRepository {
    func loadCatalog() async throws -> Catalog
    func loadProcedure(id: String) async throws -> Procedure
    func loadHelp() async throws -> HelpContent
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

    private func decode<T: Decodable>(_ type: T.Type, file: String) throws -> T {
        guard let url = bundle.url(forResource: file, withExtension: "json") else {
            throw ContentError.missingFile(file)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }
}
