import SwiftUI

/// Encadré coloré : exemple, astuce ou information.
struct Callout: View {
    enum Kind {
        case example, tip, info

        var symbol: String {
            switch self {
            case .example: "lightbulb"
            case .tip: "sparkles"
            case .info: "info.circle"
            }
        }

        var title: LocalizedStringKey {
            switch self {
            case .example: "Exemple"
            case .tip: "Astuce"
            case .info: "Bon à savoir"
            }
        }

        var tint: Color {
            switch self {
            case .example: Brand.teal
            case .tip: .orange
            case .info: .indigo
            }
        }
    }

    let kind: Kind
    let text: LocalizedText

    init(_ kind: Kind, _ text: LocalizedText) {
        self.kind = kind
        self.text = text
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: kind.symbol)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(kind.tint)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 3) {
                Text(kind.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(kind.tint)
                ContentText(text)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(kind.tint.opacity(0.10), in: .rect(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}
