import SwiftData
import SwiftUI

/// Onglet "Mes dossiers" : les démarches commencées, avec leur avancement.
struct MyFilesView: View {
    let onBrowse: () -> Void

    @Environment(ContentStore.self) private var store
    @Query(sort: \SavedProcedure.updatedAt, order: .reverse) private var saved: [SavedProcedure]

    var body: some View {
        Group {
            let entries = saved.compactMap { store.entry(id: $0.procedureId) }
            if entries.isEmpty {
                ContentUnavailableView {
                    Label("Aucun dossier en cours", systemImage: "tray")
                } description: {
                    Text("Quand vous commencez une démarche, elle apparaît ici avec votre liste de pièces.")
                } actions: {
                    Button("Voir les démarches", action: onBrowse)
                        .primaryGlassButton()
                }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                            ProcedureCard(entry: entry)
                                .staggeredAppear(index)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(AppBackground())
        .navigationTitle("Mes dossiers")
    }
}
