import SwiftUI

/// Dates importantes calculées à partir des dates saisies (ex. : fin de validité du titre).
struct DatesSection: View {
    let procedure: Procedure
    let deadlines: [(deadline: Deadline, date: Date)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Calculées à partir des dates que vous avez indiquées.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            ForEach(deadlines, id: \.deadline.id) { item in
                DateCard(procedure: procedure, deadline: item.deadline, date: item.date)
            }
        }
    }
}

private struct DateCard: View {
    let procedure: Procedure
    let deadline: Deadline
    let date: Date
    @Environment(\.locale) private var locale

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 2) {
                Text(verbatim: date.formatted(.dateTime.day().locale(locale)))
                    .font(.title2.weight(.bold).monospacedDigit())
                Text(verbatim: date.formatted(.dateTime.month(.abbreviated).year().locale(locale)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 70)
            .padding(.vertical, 8)
            .insetSurface()

            VStack(alignment: .leading, spacing: 6) {
                ContentText(deadline.title)
                    .font(.body.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                Text(date, format: .relative(presentation: .named))
                    .font(.subheadline)
                    .foregroundStyle(date < .now ? AnyShapeStyle(.orange) : AnyShapeStyle(Brand.teal))
                SourcesList(sources: procedure.sources(for: deadline.sources))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 20)
    }
}
