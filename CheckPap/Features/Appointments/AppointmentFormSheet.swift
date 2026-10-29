import SwiftUI

/// "J'ai pris rendez-vous" : date, heure, lieu et notes.
struct AppointmentFormSheet: View {
    let procedureTitle: String
    var existing: PlannedAppointment?
    let onSave: (Date, String, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var date = Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now
    @State private var place = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Date et heure", selection: $date, in: Date.now..., displayedComponents: [.date, .hourAndMinute])
                } header: {
                    Text("Quand ?")
                }
                Section {
                    TextField("Ex. : Préfecture du Val-de-Marne, Créteil", text: $place, axis: .vertical)
                } header: {
                    Text("Où ?")
                }
                Section {
                    TextField("Ex. : numéro de rendez-vous, guichet, pièces à ne pas oublier", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("Notes")
                }
            }
            .navigationTitle(Text(verbatim: procedureTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        onSave(date, place.trimmingCharacters(in: .whitespacesAndNewlines), notes)
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let existing {
                    date = existing.date
                    place = existing.place
                    notes = existing.notes
                }
            }
        }
    }
}
