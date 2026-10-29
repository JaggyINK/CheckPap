import SwiftUI

/// "À savoir pour votre situation" : les orientations qui concernent la personne,
/// repliées par défaut pour ne pas noyer la liste.
struct WarningsSection: View {
    let procedure: Procedure
    let outcomes: [Outcome]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("À savoir pour votre situation", systemImage: "exclamationmark.triangle")
                .font(.headline)
                .foregroundStyle(.orange)
            ForEach(outcomes) { outcome in
                WarningCard(procedure: procedure, outcome: outcome)
            }
        }
    }
}

private struct WarningCard: View {
    let procedure: Procedure
    let outcome: Outcome
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.snappy) { expanded.toggle() }
            } label: {
                HStack(alignment: .top) {
                    ContentText(outcome.title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.down")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(expanded ? 180 : 0))
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)

            if expanded {
                OutcomeContent(procedure: procedure, outcome: outcome)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 20)
        .overlay(alignment: .leading) {
            Capsule()
                .fill(.orange)
                .frame(width: 4)
                .padding(.vertical, 14)
        }
    }
}
