import SwiftUI

/// Onglet "Démarches" : recherche, puis les grandes catégories en tuiles.
struct ProceduresView: View {
    @Environment(ContentStore.self) private var store
    @State private var query = ""

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Vos démarches, une étape à la fois.")
                        .font(.largeTitle.weight(.bold))
                        .fontDesign(.rounded)
                    Text("Choisissez un thème, répondez à quelques questions et retrouvez les pièces demandées.")
                        .foregroundStyle(.secondary)
                }
                .staggeredAppear(0)

                if query.isEmpty {
                    ResumeSection()
                    FeaturedSection()
                    Text("Tous les thèmes")
                        .font(.headline)
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Array(store.availableCategories.enumerated()), id: \.element.id) { index, category in
                            CategoryTile(category: category)
                                .staggeredAppear(index + 1)
                        }
                    }
                } else {
                    searchResults
                }

                IndependentServiceNotice()
                    .padding(14)
                    .glassCard(cornerRadius: 18)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
        .navigationTitle("Démarches")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: Text("Rechercher une démarche"))
        .onAppear(perform: openRequestedCountry)
    }

    @Environment(Router.self) private var router

    /// Pour les captures d'écran et la vérification : `-openCountry BD` ouvre directement une fiche pays.
    private func openRequestedCountry() {
        #if DEBUG
        if let id = UserDefaults.standard.string(forKey: "openCountry"), router.path.isEmpty {
            router.path = [.countries, .country(id)]
        }
        #endif
    }

    @ViewBuilder
    private var searchResults: some View {
        let results = ProcedureSearch.filter(store.availableEntries, query: query)
        if results.isEmpty {
            ContentUnavailableView.search(text: query)
        } else {
            VStack(spacing: 12) {
                ForEach(results) { ProcedureCard(entry: $0) }
            }
        }
    }
}

/// Recherche sans tenir compte des accents ni des majuscules, en français et en anglais.
enum ProcedureSearch {
    static func filter(_ entries: [CatalogEntry], query: String) -> [CatalogEntry] {
        let needle = normalize(query)
        guard !needle.isEmpty else { return entries }
        return entries.filter { entry in
            (Array(entry.title.values.values) + Array(entry.subtitle.values.values))
                .contains { normalize($0).contains(needle) }
        }
    }

    static func normalize(_ text: String) -> String {
        text.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .trimmingCharacters(in: .whitespaces)
    }
}
