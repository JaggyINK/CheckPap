import SwiftData
import SwiftUI

/// Onglet "Mes dossiers" : les démarches commencées, avec leur avancement.
/// Glisser vers la gauche ou appui long pour supprimer un dossier.
struct MyFilesView: View {
    let onBrowse: () -> Void

    @Environment(ContentStore.self) private var store
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedProcedure.updatedAt, order: .reverse) private var saved: [SavedProcedure]
    @Query private var planned: [PlannedAppointment]
    @State private var toDelete: CatalogEntry?

    var body: some View {
        let entries = saved.compactMap { store.entry(id: $0.procedureId) }
        List {
            PermitCard()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))

            if entries.isEmpty {
                ContentUnavailableView {
                    Label("Aucun dossier en cours", systemImage: "tray")
                } description: {
                    Text("Quand vous commencez une démarche, elle apparaît ici avec votre liste de pièces.")
                } actions: {
                    Button("Voir les démarches", action: onBrowse)
                        .primaryButton()
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            } else {
                Section {
                    ForEach(entries) { entry in
                        ProcedureCard(entry: entry)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                            .swipeActions {
                                Button(role: .destructive) { toDelete = entry } label: {
                                    Label("Supprimer", systemImage: "trash")
                                }
                            }
                            .contextMenu {
                                Button(role: .destructive) { toDelete = entry } label: {
                                    Label("Supprimer ce dossier", systemImage: "trash")
                                }
                            }
                    }
                } header: {
                    Text("Mes démarches en cours")
                } footer: {
                    Text("Glissez un dossier vers la gauche pour le supprimer.")
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(AppBackground())
        .navigationTitle("Mes dossiers")
        .confirmationDialog(
            "Supprimer ce dossier ? Vos réponses, vos coches et votre rendez-vous enregistré seront effacés.",
            isPresented: Binding(get: { toDelete != nil }, set: { if !$0 { toDelete = nil } }),
            titleVisibility: .visible
        ) {
            Button("Supprimer", role: .destructive) {
                if let entry = toDelete { delete(entry.id) }
            }
        }
    }

    private func delete(_ procedureId: String) {
        withAnimation {
            for record in saved where record.procedureId == procedureId {
                modelContext.delete(record)
            }
            for appointment in planned where appointment.procedureId == procedureId {
                NotificationService.cancel(appointment.notificationIds)
                modelContext.delete(appointment)
            }
        }
    }
}
