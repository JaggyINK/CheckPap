import SwiftUI

/// Pastille sélectionnable (filtre, réponse courte).
struct ChoiceChip: View {
    let title: Text
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            title
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background {
                    if isSelected {
                        Capsule().fill(Brand.teal)
                    } else {
                        Capsule()
                            .fill(Color(.secondarySystemGroupedBackground))
                            .overlay(Capsule().strokeBorder(Color(.separator), lineWidth: 0.5))
                    }
                }
                .contentShape(.capsule)
        }
        .buttonStyle(PressableButtonStyle())
        .sensoryFeedback(.selection, trigger: isSelected)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .animation(.snappy, value: isSelected)
    }
}
