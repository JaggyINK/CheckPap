import SwiftUI

/// Un droit ou une aide : résumé, puis en dépliant : pour qui, conditions, comment faire, liens et contacts.
struct RightCard: View {
    let right: RightItem
    let content: RightsContent

    @Environment(ContentStore.self) private var store
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.snappy) { expanded.toggle() }
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        ContentText(right.title)
                            .font(.body.weight(.semibold))
                        ContentText(right.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Vous pourriez y avoir droit")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Brand.teal)
                    }
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.primary)
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
                details
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 20)
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let who = right.who {
                section("Pour qui ?") {
                    ContentText(who).font(.subheadline)
                }
            }
            if let conditions = right.conditions, !conditions.isEmpty {
                section("Conditions principales") {
                    ForEach(Array(conditions.enumerated()), id: \.offset) { _, condition in
                        Label { ContentText(condition) } icon: { Image(systemName: "checkmark.circle") }
                            .font(.subheadline)
                    }
                }
            }
            if let steps = right.howTo, !steps.isEmpty {
                section("Comment faire") {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(verbatim: "\(index + 1).")
                                .font(.subheadline.weight(.bold).monospacedDigit())
                                .foregroundStyle(Brand.teal)
                            ContentText(step).font(.subheadline)
                        }
                    }
                }
            }
            ForEach(right.links ?? [], id: \.url) { ExternalLinkLabel(link: $0) }
            ForEach(store.help?.guides(for: right.guides) ?? []) { PracticalGuideCard(guide: $0) }
            ForEach(store.help?.contacts(for: right.contacts) ?? []) { ContactCard(contact: $0) }
            SourcesList(sources: content.sources(for: right.sources))
        }
    }

    private func section(_ title: LocalizedStringKey, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Brand.teal)
            content()
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
