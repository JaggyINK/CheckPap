import SwiftData
import SwiftUI

/// Carte d'une démarche. Une démarche déjà commencée affiche son avancement et s'ouvre sur la liste.
struct ProcedureCard: View {
    let entry: CatalogEntry

    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router
    @Query private var saved: [SavedProcedure]
    @Query private var planned: [PlannedAppointment]
    @Environment(\.locale) private var locale

    var body: some View {
        let progress = ProcedureProgress.compute(entryId: entry.id, store: store, saved: saved)
        Button {
            router.path.append(progress == nil ? .intro(entry.id) : .checklist(entry.id))
        } label: {
            HStack(spacing: 14) {
                Image(systemName: entry.symbol)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Brand.teal)
                    .frame(width: 46, height: 46)
                    .background(Brand.mint.opacity(0.18), in: .circle)

                VStack(alignment: .leading, spacing: 3) {
                    ContentText(entry.title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                    if let appointment = planned.first(where: { $0.procedureId == entry.id }), appointment.date > .now {
                        Label {
                            Text(verbatim: appointment.date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated).hour().minute().locale(locale)))
                        } icon: {
                            Image(systemName: "calendar")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Brand.teal)
                    } else if let progress {
                        Text("\(progress.done) sur \(progress.total) pièces prêtes")
                            .font(.subheadline)
                            .foregroundStyle(Brand.teal)
                    } else {
                        ContentText(entry.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                if let progress {
                    ProgressRing(progress: progress.fraction, lineWidth: 4)
                        .frame(width: 26, height: 26)
                } else {
                    Image(systemName: "chevron.forward")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
            .glassCard(cornerRadius: 22)
        }
        .buttonStyle(PressableButtonStyle())
        .accessibilityElement(children: .combine)
    }
}
