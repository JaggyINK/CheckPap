import SwiftData
import SwiftUI

/// Vue racine : pile de navigation et aiguillage des routes.
struct RootView: View {
    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case let .intro(id):
            if let procedure = store.procedures[id] { ProcedureIntroView(procedure: procedure) }
        case let .questionnaire(id):
            if let procedure = store.procedures[id] { QuestionnaireView(procedure: procedure) }
        case let .checklist(id):
            if let procedure = store.procedures[id] { ChecklistView(procedure: procedure) }
        }
    }
}
