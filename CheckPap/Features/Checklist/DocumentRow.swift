import SwiftUI

/// Une pièce : rond à cocher, titre, et détail dépliable (précisions, exemple, astuce, source).
struct DocumentRow: View {
    let procedure: Procedure
    let document: RequiredDocument
    let answers: [String: String]
    let isChecked: Bool
    let toggle: () -> Void

    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                CheckButton(isChecked: isChecked, action: toggle)
                titleButton
            }
            if expanded {
                details
                    .padding(.leading, 40)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 20)
        .opacity(isChecked && !expanded ? 0.8 : 1)
    }

    private var titleButton: some View {
        Button {
            withAnimation(.snappy) { expanded.toggle() }
        } label: {
            HStack(alignment: .top) {
                ContentText(document.title)
                    .font(.body.weight(.semibold))
                    .strikethrough(isChecked, color: .secondary)
                    .foregroundStyle(isChecked ? .secondary : .primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                Image(systemName: "chevron.down")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .rotationEffect(.degrees(expanded ? 180 : 0))
                    .padding(.top, 4)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let details = document.details {
                ContentText(details)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let example = document.example {
                Callout(.example, example)
            }
            if let tip = document.tip {
                Callout(.tip, tip)
            }
            DocumentReason(reasons: RulesEngine.reasons(for: document.condition, in: procedure, answers: answers))
            SourcesList(sources: procedure.sources(for: document.sources))
        }
    }
}

/// Le rond qui devient une coche, avec un petit rebond et une vibration légère.
private struct CheckButton: View {
    let isChecked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(isChecked ? AnyShapeStyle(Brand.teal) : AnyShapeStyle(.tertiary))
                .contentTransition(.symbolEffect(.replace))
                .symbolEffect(.bounce, value: isChecked)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(weight: .light), trigger: isChecked)
        .accessibilityLabel(isChecked ? Text("Marquer comme à préparer") : Text("Marquer comme prête"))
    }
}
