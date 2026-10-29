import SwiftData
import SwiftUI

/// Liste personnalisée : points d'attention, pièces à cocher, étapes guidées et dates.
struct ChecklistView: View {
    let procedure: Procedure

    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext
    @Query private var saved: [SavedProcedure]
    @State private var tab: ChecklistTab = .documents
    @State private var confirmRestart = false

    init(procedure: Procedure) {
        self.procedure = procedure
        let id = procedure.id
        _saved = Query(filter: #Predicate<SavedProcedure> { $0.procedureId == id })
    }

    var body: some View {
        Group {
            if let record = saved.first {
                ChecklistContent(procedure: procedure, record: record, tab: $tab)
            } else {
                ContentUnavailableView("Aucune liste", systemImage: "checklist")
            }
        }
        .background(AppBackground())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ChecklistMenu(
                    onEdit: { router.path.append(.questionnaire(procedure.id)) },
                    onRestart: { confirmRestart = true }
                )
            }
        }
        .confirmationDialog("Effacer vos réponses et vos coches pour cette démarche ?",
                            isPresented: $confirmRestart, titleVisibility: .visible) {
            Button("Recommencer", role: .destructive, action: restart)
        }
    }

    private func restart() {
        saved.forEach(modelContext.delete)
        router.path = [.intro(procedure.id)]
    }
}

enum ChecklistTab: Hashable {
    case documents, steps, dates
}

private struct ChecklistMenu: View {
    let onEdit: () -> Void
    let onRestart: () -> Void

    var body: some View {
        Menu {
            Button(action: onEdit) {
                Label("Modifier mes réponses", systemImage: "pencil")
            }
            Button(role: .destructive, action: onRestart) {
                Label("Recommencer", systemImage: "arrow.counterclockwise")
            }
        } label: {
            Image(systemName: "ellipsis")
        }
        .accessibilityLabel(Text("Options"))
    }
}
