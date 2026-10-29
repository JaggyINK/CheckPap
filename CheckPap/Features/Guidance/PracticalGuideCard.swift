import SwiftUI

/// "Comment l'obtenir ?" : fiche pratique dépliable sous une pièce ou une étape.
struct PracticalGuideCard: View {
    let guide: PracticalGuide

    @Environment(ContentStore.self) private var store
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.snappy) { expanded.toggle() }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: guide.symbol ?? "lightbulb.max")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Brand.teal)
                        .frame(width: 30, height: 30)
                        .background(Brand.mint.opacity(0.18), in: .circle)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Comment l'obtenir ?")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Brand.teal)
                        ContentText(guide.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(expanded ? 180 : 0))
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)

            if expanded {
                details
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Brand.mint.opacity(0.10), in: .rect(cornerRadius: 14, style: .continuous))
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 10) {
            ContentText(guide.summary)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(Array(guide.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(verbatim: "\(index + 1).")
                        .font(.footnote.weight(.bold).monospacedDigit())
                        .foregroundStyle(Brand.teal)
                    ContentText(step)
                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if let cost = guide.cost {
                Callout(.info, cost)
            }
            if let tip = guide.tip {
                Callout(.tip, tip)
            }
            ForEach(guide.links ?? [], id: \.url) { link in
                ExternalLinkLabel(link: link)
            }
            SourcesList(sources: store.help?.sources(for: guide.sources) ?? [])
        }
    }
}
