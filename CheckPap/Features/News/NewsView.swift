import SwiftUI

/// Onglet "Actualités" (première page) : ce qui change pour les étrangers, publié par l'administration.
struct NewsView: View {
    @Environment(ContentStore.self) private var store
    @State private var filter: String?
    @State private var showSettings = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                    .staggeredAppear(0)

                if let feed = store.news {
                    filters(feed)
                    let items = feed.items.filter { filter == nil || $0.category == filter }
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        NewsCard(item: item, featured: index == 0 && filter == nil)
                            .staggeredAppear(index + 1)
                    }
                    LastVerifiedLabel(dateString: feed.lastUpdated)
                } else if case .loading = store.state {
                    ProgressView().frame(maxWidth: .infinity).padding(.vertical, 40)
                } else {
                    ContentUnavailableView("Pas d'actualités pour le moment", systemImage: "newspaper")
                }

                IndependentServiceNotice()
                    .padding(14)
                    .cardSurface(cornerRadius: 18)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showSettings) { SettingsView() }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Wordmark()
                Spacer()
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.title3)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Brand.teal)
                .accessibilityLabel(Text("Réglages"))
            }
            .padding(.top, 8)
            VStack(alignment: .leading, spacing: 6) {
                Text("Actualités")
                    .font(.largeTitle.weight(.bold))
                Text("Lois, taxes, délais et aides : les dernières nouvelles publiées par l'administration.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func filters(_ feed: NewsFeed) -> some View {
        let categories = feed.items.map(\.category).reduce(into: [String]()) { list, id in
            if !list.contains(id) { list.append(id) }
        }
        return ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ChoiceChip(title: Text("Tout"), isSelected: filter == nil) { filter = nil }
                ForEach(categories, id: \.self) { id in
                    ChoiceChip(title: NewsCategory.title(id, store: store), isSelected: filter == id) {
                        filter = filter == id ? nil : id
                    }
                }
            }
            .padding(.vertical, 2)
        }
        .scrollIndicators(.hidden)
    }
}
