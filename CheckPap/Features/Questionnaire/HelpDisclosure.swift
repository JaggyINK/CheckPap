import SwiftUI

/// "Pourquoi cette question ?" : aide repliable sous la question.
struct HelpDisclosure: View {
    let text: LocalizedText
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.snappy) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "questionmark.circle")
                    Text("Pourquoi cette question ?")
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Brand.teal)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Callout(.info, text)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
