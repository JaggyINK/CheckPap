import SwiftUI

/// Une étape de la frise : numéro (ou coche), trait vertical, explication, lien et courriers utiles.
struct StepRow: View {
    enum State {
        case done, current, upcoming
    }

    let procedure: Procedure
    let step: GuideStep
    let number: Int
    let isLast: Bool
    let state: State
    let toggle: () -> Void

    @Environment(ContentStore.self) private var store

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                Button(action: toggle) { marker }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.impact(weight: .light), trigger: state == .done)
                    .accessibilityLabel(state == .done ? Text("Marquer l'étape comme à faire") : Text("Marquer l'étape comme faite"))
                if !isLast {
                    Rectangle()
                        .fill(state == .done ? Brand.teal.opacity(0.6) : Color(.separator))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                if state == .current {
                    Text("Étape en cours")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Brand.teal)
                }
                ContentText(step.title)
                    .font(.body.weight(.semibold))
                    .strikethrough(state == .done, color: .secondary)
                    .fixedSize(horizontal: false, vertical: true)
                ContentText(step.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if state != .done {
                    if let link = step.link {
                        ExternalLinkLabel(link: link)
                    }
                    ForEach(store.help?.guides(for: step.guides) ?? []) { PracticalGuideCard(guide: $0) }
                    ForEach(store.help?.letters(for: step.letters) ?? []) { LetterButton(letter: $0, procedure: procedure) }
                    SourcesList(sources: procedure.sources(for: step.sources))
                }
            }
            .padding(.bottom, isLast ? 0 : 22)
        }
        .opacity(state == .upcoming ? 0.45 : 1)
        .animation(.snappy, value: state)
    }

    @ViewBuilder
    private var marker: some View {
        ZStack {
            Circle()
                .fill(state == .upcoming ? AnyShapeStyle(.tertiary) : AnyShapeStyle(Brand.teal))
            if state == .done {
                Image(systemName: "checkmark")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(.white)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Text(verbatim: "\(number)")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 28, height: 28)
        .overlay {
            if state == .current {
                Circle().stroke(Brand.teal.opacity(0.35), lineWidth: 2).padding(-3)
            }
        }
    }
}
