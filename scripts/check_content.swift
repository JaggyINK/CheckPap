// Décode tous les fichiers de contenu avec les vrais modèles Swift, sans simulateur.
// Utilisation : ./scripts/check_content.sh
import Foundation

let directory = URL(fileURLWithPath: CommandLine.arguments[1])

func check<T: Decodable>(_ type: T.Type, _ path: String, summary: (T) -> String) {
    do {
        let data = try Data(contentsOf: directory.appendingPathComponent(path))
        print("OK      \(path) : \(summary(try JSONDecoder().decode(type, from: data)))")
    } catch {
        print("ERREUR  \(path) : \(error)")
    }
}

let catalogData = try Data(contentsOf: directory.appendingPathComponent("catalog.json"))
let catalog = try JSONDecoder().decode(Catalog.self, from: catalogData)
for entry in catalog.procedures {
    check(Procedure.self, "procedures/\(entry.id).json") {
        "\($0.questions.count) questions, \($0.documents.count) pièces, \($0.steps.count) étapes, \($0.outcomes?.count ?? 0) orientations"
    }
}
check(HelpContent.self, "help.json") { "\($0.contacts.count) contacts, \($0.letters.count) courriers" }
