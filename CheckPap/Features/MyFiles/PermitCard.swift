import SwiftData
import SwiftUI

/// "Mon titre de séjour" : date de fin, compte à rebours, dates de renouvellement
/// (calculées avec les règles de la démarche Renouvellement) et rappels.
struct PermitCard: View {
    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router
    @Environment(\.locale) private var locale
    @Query private var saved: [SavedProcedure]
    @State private var info = PermitInfo.load()
    @State private var editing = false
    @State private var remindersRefused = false

    private var renewal: Procedure? { store.procedures[PermitInfo.procedureId] }

    var body: some View {
        if let renewal {
            VStack(alignment: .leading, spacing: 12) {
                Label("Mon titre de séjour", systemImage: "creditcard")
                    .font(.headline)
                if let info, let expiry = info.expiryDate {
                    details(info: info, expiry: expiry, renewal: renewal)
                } else {
                    Text("Ajoutez la date de fin de votre titre de séjour : l'app vous rappellera quand déposer votre demande de renouvellement.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button {
                        editing = true
                    } label: {
                        Label("Ajouter mon titre de séjour", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .primaryButton()
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface(cornerRadius: 22)
            .sheet(isPresented: $editing) {
                PermitFormSheet(renewal: renewal, initial: info) { newInfo in
                    if let old = info { NotificationService.cancel(old.notificationIds) }
                    info = newInfo
                    PermitInfo.save(newInfo)
                }
            }
        }
    }

    @ViewBuilder
    private func details(info: PermitInfo, expiry: Date, renewal: Procedure) -> some View {
        let deadlines = RulesEngine.deadlines(in: renewal, answers: info.answers)
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Fin de validité")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(verbatim: expiry.formatted(.dateTime.day().month(.wide).year().locale(locale)))
                    .font(.title3.weight(.bold))
            }
            Spacer()
            Text(expiry, format: .relative(presentation: .named))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(expiry < .now ? AnyShapeStyle(.orange) : AnyShapeStyle(Brand.teal))
        }

        if deadlines.isEmpty {
            Text("Indiquez le type de votre titre (bouton Modifier) pour voir vos dates de renouvellement.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } else {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(deadlines, id: \.deadline.id) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: item.date < .now ? "exclamationmark.circle" : "calendar")
                            .foregroundStyle(item.date < .now ? AnyShapeStyle(.orange) : AnyShapeStyle(Brand.teal))
                        VStack(alignment: .leading, spacing: 2) {
                            ContentText(item.deadline.title)
                                .font(.subheadline.weight(.semibold))
                            Text(verbatim: item.date.formatted(.dateTime.day().month(.wide).year().locale(locale)))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }

        FlowLayout(spacing: 8) {
            Button { Task { await toggleReminders(info: info, expiry: expiry, deadlines: deadlines) } } label: {
                Label(info.notificationIds.isEmpty ? "Me le rappeler" : "Rappels activés",
                      systemImage: info.notificationIds.isEmpty ? "bell" : "bell.fill")
            }
            Button { openRenewal() } label: { Label("Préparer mon renouvellement", systemImage: "arrow.triangle.2.circlepath") }
            Button { editing = true } label: { Label("Modifier", systemImage: "pencil") }
            Button(role: .destructive) { remove(info) } label: { Label("Supprimer", systemImage: "trash") }
        }
        .font(.footnote.weight(.semibold))
        .secondaryButton()

        if remindersRefused {
            Text("Les notifications sont désactivées pour Check Pap. Vous pouvez les activer dans les Réglages de l'iPhone.")
                .font(.caption)
                .foregroundStyle(.orange)
        }
    }

    private func toggleReminders(info: PermitInfo, expiry: Date, deadlines: [(deadline: Deadline, date: Date)]) async {
        var updated = info
        if !info.notificationIds.isEmpty {
            NotificationService.cancel(info.notificationIds)
            updated.notificationIds = []
        } else {
            guard await NotificationService.requestAuthorization() else {
                remindersRefused = true
                return
            }
            let title = String(localized: "Votre titre de séjour")
            var reminders = deadlines.map { (date: $0.date, title: title, body: $0.deadline.title.resolved(locale)) }
            reminders.append((date: expiry, title: title, body: String(localized: "Votre titre de séjour arrive à sa date de fin aujourd'hui.")))
            updated.notificationIds = await NotificationService.schedule(reminders)
        }
        self.info = updated
        PermitInfo.save(updated)
    }

    private func openRenewal() {
        let started = saved.contains { $0.procedureId == PermitInfo.procedureId }
        router.path.append(started ? .checklist(PermitInfo.procedureId) : .intro(PermitInfo.procedureId))
    }

    private func remove(_ info: PermitInfo) {
        NotificationService.cancel(info.notificationIds)
        withAnimation { self.info = nil }
        PermitInfo.save(nil)
    }
}
