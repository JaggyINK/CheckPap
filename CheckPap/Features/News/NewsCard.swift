import SwiftUI

/// Une actualité : date, thème, titre, résumé, lien vers la source et démarches liées.
struct NewsCard: View {
    let item: NewsItem
    var featured = false

    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router
    @Environment(\.locale) private var locale

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Label {
                    NewsCategory.title(item.category, store: store)
                } icon: {
                    Image(systemName: NewsCategory.symbol(item.category, store: store))
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(Brand.teal)
                Spacer()
                if let date = DayDate.parse(item.date) {
                    Text(verbatim: date.formatted(.dateTime.day().month(.abbreviated).year().locale(locale)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            ContentText(item.title)
                .font(featured ? .title2.weight(.bold) : .headline)
                .fontDesign(featured ? .rounded : .default)
                .fixedSize(horizontal: false, vertical: true)
            ContentText(item.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ExternalLinkLabel(link: item.link)

            let related = (item.procedures ?? []).compactMap { store.entry(id: $0) }
            if !related.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(related) { entry in
                        Button {
                            router.path.append(.intro(entry.id))
                        } label: {
                            Label {
                                ContentText(entry.title)
                            } icon: {
                                Image(systemName: entry.symbol)
                            }
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Brand.mint.opacity(0.18), in: .capsule)
                        }
                        .buttonStyle(PressableButtonStyle())
                        .tint(Brand.teal)
                    }
                }
            }
        }
        .padding(featured ? 20 : 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: featured ? 26 : 20)
        .overlay(alignment: .topLeading) {
            if featured {
                Text("À la une")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Brand.teal, in: .capsule)
                    .offset(x: 16, y: -10)
            }
        }
    }
}
