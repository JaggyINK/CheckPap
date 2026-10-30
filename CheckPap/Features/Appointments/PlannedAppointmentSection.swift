import SwiftData
import SwiftUI

/// "Avez-vous pris rendez-vous ?" puis, une fois enregistré : la date, le lieu,
/// l'ajout au calendrier et les rappels.
struct PlannedAppointmentSection: View {
    let procedure: Procedure

    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) private var locale
    @Query private var planned: [PlannedAppointment]
    @State private var editing = false
    @State private var addingToCalendar = false
    @State private var remindersRefused = false

    init(procedure: Procedure) {
        self.procedure = procedure
        let id = procedure.id
        _planned = Query(filter: #Predicate<PlannedAppointment> { $0.procedureId == id })
    }

    private var title: String { procedure.title.resolved(locale) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let appointment = planned.first {
                details(appointment)
            } else {
                Text("Avez-vous déjà pris rendez-vous ?")
                    .font(.subheadline.weight(.semibold))
                Button {
                    editing = true
                } label: {
                    Label("Oui, j'enregistre mon rendez-vous", systemImage: "calendar.badge.plus")
                        .frame(maxWidth: .infinity)
                }
                .secondaryButton()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 20)
        .sheet(isPresented: $editing) {
            AppointmentFormSheet(procedureTitle: title, existing: planned.first, onSave: save)
        }
        .sheet(isPresented: $addingToCalendar) {
            if let appointment = planned.first {
                AddToCalendarSheet(title: title, date: appointment.date, location: appointment.place, notes: appointment.notes)
                    .ignoresSafeArea()
            }
        }
    }

    @ViewBuilder
    private func details(_ appointment: PlannedAppointment) -> some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 2) {
                Text(verbatim: appointment.date.formatted(.dateTime.day().locale(locale)))
                    .font(.title.weight(.bold).monospacedDigit())
                Text(verbatim: appointment.date.formatted(.dateTime.month(.abbreviated).locale(locale)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 64)
            .padding(.vertical, 8)
            .insetSurface()

            VStack(alignment: .leading, spacing: 4) {
                Text("Votre rendez-vous")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Brand.teal)
                Text(verbatim: appointment.date.formatted(.dateTime.weekday(.wide).day().month(.wide).hour().minute().locale(locale)))
                    .font(.headline)
                if !appointment.place.isEmpty {
                    Label { Text(verbatim: appointment.place) } icon: { Image(systemName: "mappin") }
                        .font(.subheadline)
                }
                Text(appointment.date, format: .relative(presentation: .named))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Brand.teal)
            }
        }
        if !appointment.notes.isEmpty {
            Text(verbatim: appointment.notes)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        FlowLayout(spacing: 8) {
            Button { addingToCalendar = true } label: { Label("Ajouter au calendrier", systemImage: "calendar") }
            Button { Task { await toggleReminders(appointment) } } label: {
                Label(appointment.notificationIds.isEmpty ? "Me le rappeler" : "Rappels activés",
                      systemImage: appointment.notificationIds.isEmpty ? "bell" : "bell.fill")
            }
            Button { editing = true } label: { Label("Modifier", systemImage: "pencil") }
            Button(role: .destructive) { delete(appointment) } label: { Label("Supprimer", systemImage: "trash") }
        }
        .font(.footnote.weight(.semibold))
        .secondaryButton()
        if remindersRefused {
            Text("Les notifications sont désactivées pour Check Pap. Vous pouvez les activer dans les Réglages de l'iPhone.")
                .font(.caption)
                .foregroundStyle(.orange)
        }
    }

    private func save(date: Date, place: String, notes: String) {
        if let appointment = planned.first {
            NotificationService.cancel(appointment.notificationIds)
            appointment.notificationIds = []
            appointment.date = date
            appointment.place = place
            appointment.notes = notes
        } else {
            modelContext.insert(PlannedAppointment(procedureId: procedure.id, date: date, place: place, notes: notes))
        }
    }

    private func toggleReminders(_ appointment: PlannedAppointment) async {
        if !appointment.notificationIds.isEmpty {
            NotificationService.cancel(appointment.notificationIds)
            appointment.notificationIds = []
            return
        }
        guard await NotificationService.requestAuthorization() else {
            remindersRefused = true
            return
        }
        let body = appointment.place.isEmpty ? title : "\(title) · \(appointment.place)"
        appointment.notificationIds = await NotificationService.schedule(
            title: String(localized: "Rendez-vous bientôt"), body: body, at: appointment.date
        )
    }

    private func delete(_ appointment: PlannedAppointment) {
        NotificationService.cancel(appointment.notificationIds)
        modelContext.delete(appointment)
    }
}
