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
check(HelpContent.self, "help.json") { "\($0.contacts.count) contacts, \($0.letters.count) courriers, \($0.guides?.count ?? 0) fiches pratiques" }

if FileManager.default.fileExists(atPath: directory.appendingPathComponent("news.json").path) {
    check(NewsFeed.self, "news.json") { "\($0.items.count) actualités" }
}
check(RightsProfile.self, "rights.json") { "\($0.questions.count) questions de profil" }
let profileData = try Data(contentsOf: directory.appendingPathComponent("rights.json"))
for part in try JSONDecoder().decode(RightsProfile.self, from: profileData).parts
    where FileManager.default.fileExists(atPath: directory.appendingPathComponent("\(part).json").path) {
    check(RightsPart.self, "\(part).json") { "\($0.rights.count) droits" }
}

for (file, describe) in [
    ("countries.json", { (data: Data) in "\(try JSONDecoder().decode(CountryList.self, from: data).countries.count) pays" }),
    ("countries_details.json", { (data: Data) in "\(try JSONDecoder().decode(CountryDetailsFile.self, from: data).details.count) fiches détaillées" }),
    ("countries_budget.json", { (data: Data) in
        let budget = try JSONDecoder().decode(CountryBudgetFile.self, from: data)
        return "\(budget.perDiem.count) barèmes, \(budget.rates.perEuro.count) taux, \(budget.workingHoliday?.count ?? 0) PVT"
    }),
] as [(String, (Data) throws -> String)] {
    let url = directory.appendingPathComponent(file)
    guard FileManager.default.fileExists(atPath: url.path) else { continue }
    do {
        print("OK      \(file) : \(try describe(Data(contentsOf: url)))")
    } catch {
        print("ERREUR  \(file) : \(error)")
    }
}

if FileManager.default.fileExists(atPath: directory.appendingPathComponent("prefectures.json").path) {
    check(PrefectureDirectory.self, "prefectures.json") { directory in
        "\(directory.departments.count) départements, \(directory.departments.filter { $0.appointmentUrl != nil }.count) avec page de rendez-vous"
    }
}
