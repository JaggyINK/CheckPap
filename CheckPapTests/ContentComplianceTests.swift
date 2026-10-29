import Foundation
import Testing
@testable import CheckPap

/// Vérifie le vrai contenu livré dans l'app : décodage, sources, traductions, garde-fous.
/// Ces tests transforment les règles de docs/content-schema.md en contrôles automatiques.
struct ContentComplianceTests {
    static let allowedHosts = [
        "service-public.gouv.fr", "service-public.fr",
        "administration-etrangers-en-france.interieur.gouv.fr", "interieur.gouv.fr",
        "legifrance.gouv.fr", "ofii.fr", "france-visas.gouv.fr", "demarches.interieur.gouv.fr",
        "immigration.interieur.gouv.fr", "data.gouv.fr", "lannuaire.service-public.gouv.fr",
        "defenseurdesdroits.fr", "justice.fr", "ameli.fr", "france-education-international.fr",
        "courdecassation.fr", "cci-paris-idf.fr", "caf.fr", "msa.fr", "francetravail.fr",
        "banque-france.fr", "visale.fr", "actionlogement.fr", "conseil-constitutionnel.fr", "conseil-etat.fr",
        "cleiss.fr", "cfe.fr", "aefe.fr", "civiweb.com", "businessfrance.fr", "info-retraite.fr", "assemblee-afe.fr",
    ]

    /// Formules de promesse de résultat. "garantie" seul reste permis (ex. : "Garantie Visale").
    static let promises = [
        "vous obtiendrez votre titre", "vous obtiendrez la nationalité", "succès garanti", "réussite garantie",
        "accord garanti", "c'est garanti", "nous garantissons", "garanti à 100",
        "guaranteed approval", "guaranteed success", "you will be granted",
    ]

    /// Clés de langue possibles dans un texte traduit (voir AppLanguage).
    static let languageCodes: Set<String> = [
        "fr", "en", "ar", "bn", "hi", "zh-Hans", "ru", "id", "th", "tr", "uk", "fa", "ps", "ur", "ta", "ti", "pt", "es",
    ]

    static func isAllowed(_ url: URL) -> Bool {
        guard url.scheme == "https", let host = url.host() else { return false }
        return allowedHosts.contains { host == $0 || host.hasSuffix("." + $0) } || host.hasSuffix(".gouv.fr")
    }

    static var catalog: Catalog {
        get throws {
            let url = try #require(Bundle.main.url(forResource: "catalog", withExtension: "json"))
            return try JSONDecoder().decode(Catalog.self, from: Data(contentsOf: url))
        }
    }

    static func procedureIds() throws -> [String] {
        try catalog.procedures.map(\.id)
    }

    static func rawJSON(_ id: String) throws -> (data: Data, text: String) {
        let url = try #require(Bundle.main.url(forResource: id, withExtension: "json"), "Fichier manquant : \(id).json")
        let data = try Data(contentsOf: url)
        return (data, String(decoding: data, as: UTF8.self))
    }

    static func procedure(_ id: String) throws -> Procedure {
        try JSONDecoder().decode(Procedure.self, from: rawJSON(id).data)
    }

    @Test func catalogDecodes() throws {
        #expect(try !Self.catalog.procedures.isEmpty)
    }

    @Test func procedureDecodes() throws {
        for id in try Self.procedureIds() {
            let procedure = try Self.procedure(id)
            #expect(procedure.id == id)
            #expect(!procedure.questions.isEmpty)
            #expect(!procedure.documents.isEmpty)
            #expect(!procedure.steps.isEmpty)
            #expect(DayDate.parse(procedure.lastVerified) != nil)
        }
    }

    @Test func everyItemHasKnownSources() throws {
        for id in try Self.procedureIds() {
            let procedure = try Self.procedure(id)
            let known = Set(procedure.sources.map(\.id))
            let cited: [(String, [String])] =
                procedure.questions.map { ($0.id, $0.sources) }
                + procedure.documents.map { ($0.id, $0.sources) }
                + procedure.steps.map { ($0.id, $0.sources) }
                + (procedure.deadlines ?? []).map { ($0.id, $0.sources) }
                + (procedure.outcomes ?? []).map { ($0.id, $0.sources) }
                + (procedure.appointments ?? []).map { ($0.id, $0.sources) }
            for (item, sources) in cited {
                #expect(!sources.isEmpty, "\(id) / \(item) : aucune source")
                for source in sources {
                    #expect(known.contains(source), "\(id) / \(item) : source inconnue \(source)")
                }
            }
        }
    }

    @Test func sourcesAndLinksPointToAllowedSites() throws {
        for id in try Self.procedureIds() {
            let procedure = try Self.procedure(id)
            for source in procedure.sources {
                #expect(Self.isAllowed(source.url), "\(id) : source hors domaines autorisés \(source.url)")
            }
            for step in procedure.steps {
                if let link = step.link {
                    #expect(Self.isAllowed(link.url), "\(id) / \(step.id) : lien hors domaines autorisés \(link.url)")
                }
            }
        }
    }

    @Test func conditionsReferenceEarlierQuestionsAndValidValues() throws {
        for id in try Self.procedureIds() {
            let procedure = try Self.procedure(id)
            var asked: [String: Question] = [:]

            func check(_ condition: Condition?, owner: String) {
                for reference in condition?.references ?? [] {
                    guard let question = asked[reference.question] else {
                        Issue.record("\(id) / \(owner) : question \(reference.question) inconnue ou posée plus loin")
                        continue
                    }
                    let valid = Set(question.choices.map(\.id))
                    for value in reference.values where !valid.contains(value) {
                        Issue.record("\(id) / \(owner) : valeur \(value) inexistante pour \(question.id)")
                    }
                }
            }

            for question in procedure.questions {
                check(question.condition, owner: question.id)
                asked[question.id] = question
            }
            procedure.documents.forEach { check($0.condition, owner: $0.id) }
            procedure.steps.forEach { check($0.condition, owner: $0.id) }
            procedure.outcomes?.forEach { check($0.condition, owner: $0.id) }
        procedure.appointments?.forEach { check($0.condition, owner: $0.id) }
            for deadline in procedure.deadlines ?? [] {
                check(deadline.condition, owner: deadline.id)
                #expect(asked[deadline.relativeTo]?.kind == .date, "\(id) / \(deadline.id) : relativeTo doit être une question date")
            }
        }
    }

    @Test func everyTextIsTranslated() throws {
        for id in try Self.procedureIds() {
            let json = try JSONSerialization.jsonObject(with: Self.rawJSON(id).data)
            var missing: [String] = []

            func visit(_ value: Any, path: String) {
                if let dict = value as? [String: Any] {
                    if !dict.isEmpty, dict.keys.contains("fr"), dict.keys.allSatisfy({ Self.languageCodes.contains($0) }) {
                        for language in ["fr", "en"] where (dict[language] as? String ?? "").isEmpty {
                            missing.append("\(path).\(language)")
                        }
                    } else {
                        for (key, child) in dict { visit(child, path: "\(path).\(key)") }
                    }
                } else if let array = value as? [Any] {
                    for (index, child) in array.enumerated() { visit(child, path: "\(path)[\(index)]") }
                }
            }

            visit(json, path: id)
            #expect(missing.isEmpty, "Traductions manquantes : \(missing)")
        }
    }

    @Test func guardRailsAreRespected() throws {
        for id in try Self.procedureIds() {
            let procedure = try Self.procedure(id)
            let text = try Self.rawJSON(id).text
            #expect(!text.contains("\u{2014}"), "\(id) : tiret cadratin interdit")

            var displayed: [LocalizedText?] = [procedure.title, procedure.summary]
            for question in procedure.questions {
                displayed += [question.title, question.help, question.example] + question.choices.map(\.label)
            }
            for document in procedure.documents {
                displayed += [document.title, document.details, document.example, document.tip]
            }
            for step in procedure.steps {
                displayed += [step.title, step.body, step.link?.title]
            }
            for outcome in procedure.outcomes ?? [] {
                displayed += [outcome.title, outcome.body]
                displayed += (outcome.actions ?? []).flatMap { [$0.title, $0.body, $0.link?.title] }
            }
            for value in displayed.compactMap({ $0 }).flatMap({ Array($0.values.values) }) {
                let lower = value.lowercased()
                #expect(!lower.contains("officiel"), "\(id) : mot interdit dans « \(value) »")
                for promise in Self.promises where lower.contains(promise) {
                    Issue.record("\(id) : promesse interdite (« \(promise) ») dans « \(value) »")
                }
            }
        }
    }

    @Test func contactsAndLettersExistInHelp() throws {
        for id in try Self.procedureIds() {
            let procedure = try Self.procedure(id)
            let url = try #require(Bundle.main.url(forResource: "help", withExtension: "json"), "help.json manquant")
            let help = try JSONDecoder().decode(HelpContent.self, from: Data(contentsOf: url))
            let contactIds = Set(help.contacts.map(\.id))
            let letterIds = Set(help.letters.map(\.id))
            for outcome in procedure.outcomes ?? [] {
                for contact in outcome.contacts ?? [] {
                    #expect(contactIds.contains(contact), "\(id) / \(outcome.id) : contact inconnu \(contact)")
                }
                for letter in outcome.letters ?? [] {
                    #expect(letterIds.contains(letter), "\(id) / \(outcome.id) : courrier inconnu \(letter)")
                }
            }
            for step in procedure.steps {
                for letter in step.letters ?? [] {
                    #expect(letterIds.contains(letter), "\(id) / \(step.id) : courrier inconnu \(letter)")
                }
            }
        }
    }

    @Test func helpContentFollowsTheRules() throws {
        let url = try #require(Bundle.main.url(forResource: "help", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let help = try JSONDecoder().decode(HelpContent.self, from: data)
        let known = Set(help.sources.map(\.id))
        for source in help.sources {
            #expect(Self.isAllowed(source.url), "help : source hors domaines autorisés \(source.url)")
        }
        for guide in help.guides ?? [] {
            for link in guide.links ?? [] {
                #expect(Self.isAllowed(link.url), "help / \(guide.id) : lien hors domaines autorisés \(link.url)")
            }
        }
        for item in help.contacts.map({ ($0.id, $0.sources) }) + help.letters.map({ ($0.id, $0.sources) })
            + (help.guides ?? []).map({ ($0.id, $0.sources) }) {
            #expect(!item.1.isEmpty, "help / \(item.0) : aucune source")
            #expect(item.1.allSatisfy(known.contains), "help / \(item.0) : source inconnue")
        }
        let text = String(decoding: data, as: UTF8.self)
        #expect(!text.contains("\u{2014}"), "help : tiret cadratin interdit")
        let displayed = help.contacts.flatMap { [$0.title, $0.body] } + help.letters.flatMap { [$0.title, $0.purpose, $0.summary] }
        for value in displayed.flatMap({ Array($0.values.values) }) + help.letters.flatMap({ [$0.subject, $0.body] }) {
            #expect(!value.lowercased().contains("officiel"), "help : mot interdit dans « \(value) »")
        }
    }

    /// Une pièce affichée à tout le monde ne doit pas annoncer "seulement si..." : c'est le rôle d'une condition.
    @Test func unconditionalDocumentsAreReallyForEveryone() throws {
        for id in try Self.procedureIds() {
            let procedure = try Self.procedure(id)
            for document in procedure.documents where document.condition == nil {
                let title = (document.title.values["fr"] ?? "").lowercased()
                for marker in ["seulement", "uniquement", "le cas échéant", "si vous", "si votre"] {
                    #expect(!title.contains(marker), "\(id) / \(document.id) : « \(marker) » dans le titre mais aucune condition")
                }
            }
        }
    }

    @Test func everyProcedureIsFiledInAnExistingSubcategory() throws {
        let catalog = try Self.catalog
        let categories = catalog.categories ?? []
        #expect(!categories.isEmpty, "catalog.json : aucune catégorie")
        for entry in catalog.procedures {
            let category = categories.first { $0.id == entry.category }
            #expect(category != nil, "\(entry.id) : catégorie inconnue \(entry.category ?? "aucune")")
            #expect(category?.subcategories.contains { $0.id == entry.subcategory } == true,
                    "\(entry.id) : sous-catégorie inconnue \(entry.subcategory ?? "aucune")")
        }
    }

    @Test func newsFollowsTheRules() throws {
        let url = try #require(Bundle.main.url(forResource: "news", withExtension: "json"), "news.json manquant")
        let feed = try JSONDecoder().decode(NewsFeed.self, from: Data(contentsOf: url))
        let catalog = try Self.catalog
        let categoryIds = Set((catalog.categories ?? []).map(\.id) + ["rights"])
        let procedureIds = Set(catalog.procedures.map(\.id))
        #expect(!feed.items.isEmpty)
        for item in feed.items {
            #expect(DayDate.parse(item.date) != nil, "news / \(item.id) : date invalide")
            #expect(categoryIds.contains(item.category), "news / \(item.id) : catégorie inconnue \(item.category)")
            #expect(Self.isAllowed(item.link.url), "news / \(item.id) : lien hors domaines autorisés \(item.link.url)")
            for text in [item.title, item.summary] {
                #expect(text.values["fr"]?.isEmpty == false && text.values["en"]?.isEmpty == false, "news / \(item.id) : traduction manquante")
            }
            for procedure in item.procedures ?? [] where !procedureIds.contains(procedure) {
                // Une démarche pas encore publiée est simplement ignorée par l'app ; on le signale sans échouer.
                print("news / \(item.id) : démarche pas encore au catalogue \(procedure)")
            }
        }
    }

    @Test func rightsFollowTheRules() throws {
        let profileURL = try #require(Bundle.main.url(forResource: "rights", withExtension: "json"))
        let profile = try JSONDecoder().decode(RightsProfile.self, from: Data(contentsOf: profileURL))
        let helpURL = try #require(Bundle.main.url(forResource: "help", withExtension: "json"))
        let help = try JSONDecoder().decode(HelpContent.self, from: Data(contentsOf: helpURL))
        let questions = Dictionary(uniqueKeysWithValues: profile.questions.map { ($0.id, $0) })
        for part in profile.parts {
            let url = try #require(Bundle.main.url(forResource: part, withExtension: "json"), "\(part).json manquant")
            let content = try JSONDecoder().decode(RightsPart.self, from: Data(contentsOf: url))
            let known = Set(content.sources.map(\.id))
            for source in content.sources {
                #expect(Self.isAllowed(source.url), "\(part) : source hors domaines autorisés \(source.url)")
            }
            for right in content.rights {
                #expect(!right.sources.isEmpty && right.sources.allSatisfy(known.contains), "\(part) / \(right.id) : sources")
                for link in right.links ?? [] {
                    #expect(Self.isAllowed(link.url), "\(part) / \(right.id) : lien hors domaines autorisés \(link.url)")
                }
                for reference in right.condition?.references ?? [] {
                    let question = questions[reference.question]
                    #expect(question != nil, "\(part) / \(right.id) : question de profil inconnue \(reference.question)")
                    let valid = Set(question?.choices.map(\.id) ?? [])
                    for value in reference.values where !valid.contains(value) {
                        Issue.record("\(part) / \(right.id) : valeur \(value) inexistante pour \(reference.question)")
                    }
                }
                #expect((right.contacts ?? []).allSatisfy { id in help.contacts.contains { $0.id == id } }, "\(part) / \(right.id) : contact inconnu")
                #expect((right.guides ?? []).allSatisfy { id in (help.guides ?? []).contains { $0.id == id } }, "\(part) / \(right.id) : fiche inconnue")
                let texts = [right.title, right.summary, right.who].compactMap { $0 } + (right.conditions ?? []) + (right.howTo ?? [])
                for value in texts.flatMap({ Array($0.values.values) }) {
                    #expect(!value.lowercased().contains("officiel"), "\(part) / \(right.id) : mot interdit")
                    #expect(!value.contains("\u{2014}"), "\(part) / \(right.id) : tiret cadratin")
                }
            }
        }
    }

    /// Fiches pays : les liens peuvent mener aux sites des autres États, mais restent en https,
    /// et chaque information détaillée cite une source déclarée.
    @Test func countriesFollowTheRules() throws {
        let listURL = try #require(Bundle.main.url(forResource: "countries", withExtension: "json"))
        let list = try JSONDecoder().decode(CountryList.self, from: Data(contentsOf: listURL))
        #expect(list.countries.count > 150)
        #expect(Set(list.countries.map(\.id)).count == list.countries.count, "countries : identifiants en double")
        for country in list.countries {
            #expect(!country.links.isEmpty, "countries / \(country.id) : aucun lien")
            for link in country.links {
                #expect(link.url.scheme == "https", "countries / \(country.id) : lien non https")
            }
        }
        if let url = Bundle.main.url(forResource: "countries_details", withExtension: "json") {
            let details = try JSONDecoder().decode(CountryDetailsFile.self, from: Data(contentsOf: url))
            let known = Set(details.sources.map(\.id))
            let ids = Set(list.countries.map(\.id))
            for detail in details.details {
                #expect(ids.contains(detail.country), "countries_details : pays inconnu \(detail.country)")
                let cited = detail.highlights.flatMap(\.sources) + (detail.motives ?? []).flatMap(\.sources)
                #expect(cited.allSatisfy(known.contains), "countries_details / \(detail.country) : source inconnue")
            }
        }
        if let url = Bundle.main.url(forResource: "countries_budget", withExtension: "json") {
            let budget = try JSONDecoder().decode(CountryBudgetFile.self, from: Data(contentsOf: url))
            #expect(DayDate.parse(budget.rates.date) != nil)
            #expect(budget.perDiem.allSatisfy { $0.amount > 0 })
            #expect(budget.rates.perEuro.values.allSatisfy { $0 > 0 })
        }
    }

    @Test func prefecturesFollowTheRules() throws {
        guard let url = Bundle.main.url(forResource: "prefectures", withExtension: "json") else { return }
        let directory = try JSONDecoder().decode(PrefectureDirectory.self, from: Data(contentsOf: url))
        #expect(directory.departments.count >= 101, "prefectures : \(directory.departments.count) départements")
        #expect(Set(directory.departments.map(\.code)).count == directory.departments.count, "prefectures : codes en double")
        for department in directory.departments {
            for link in [department.website, department.appointmentUrl, department.subprefecturesUrl].compactMap({ $0 }) {
                #expect(Self.isAllowed(link), "prefectures / \(department.code) : lien hors domaines autorisés \(link)")
            }
            #expect(!department.sources.isEmpty, "prefectures / \(department.code) : aucune source")
        }
    }
}
