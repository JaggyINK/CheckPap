import SwiftUI

/// Aiguillage : quelle vue afficher pour chaque route.
struct RouteDestination: View {
    let route: Route
    @Environment(ContentStore.self) private var store

    var body: some View {
        switch route {
        case let .category(id):
            if let category = store.availableCategories.first(where: { $0.id == id }) {
                CategoryDetailView(category: category)
            }
        case let .intro(id):
            if let procedure = store.procedures[id] { ProcedureIntroView(procedure: procedure) }
        case let .questionnaire(id):
            if let procedure = store.procedures[id] { QuestionnaireView(procedure: procedure) }
        case let .checklist(id):
            if let procedure = store.procedures[id] { ChecklistView(procedure: procedure) }
        case .countries:
            CountryListView()
        case let .country(id):
            if let country = store.countries?.country(id: id) { CountryDetailView(country: country) }
        }
    }
}
