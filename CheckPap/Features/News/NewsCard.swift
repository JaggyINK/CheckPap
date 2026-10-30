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
            if featured {
                Text("À la une")
                    .font(.caption.weight(.bold))
                    .textCase(.uppercase)
                    .foregroundStyle(Brand.teal)
            }
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
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .tint(Brand.teal)
                    }
                }
            }
        }
        .padding(featured ? 20 : 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: featured ? 26 : 20)
    }
}
