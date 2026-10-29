import SwiftUI

/// Une réponse possible, en carte de verre. La coche apparaît avec une petite animation.
struct OptionButton: View {
    let option: AnswerOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    ContentText(option.label)
                        .font(.body.weight(.semibold))
                    if let help = option.help {
                        ContentText(help)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .multilineTextAlignment(.leading)
                .foregroundStyle(.primary)

                Spacer(minLength: 0)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? AnyShapeStyle(Brand.teal) : AnyShapeStyle(.tertiary))
                    .contentTransition(.symbolEffect(.replace))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
            .glassCard(cornerRadius: 18)
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Brand.teal, lineWidth: isSelected ? 2 : 0)
            }
        }
        .buttonStyle(PressableButtonStyle())
        .sensoryFeedback(.selection, trigger: isSelected)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
