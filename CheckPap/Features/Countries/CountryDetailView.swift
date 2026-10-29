import SwiftUI

/// Fiche pays : informations détaillées quand elles existent, puis les liens utiles.
struct CountryDetailView: View {
    let country: Country

    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router

    var body: some View {
        let highlights = store.countries?.highlights(for: country.id) ?? []
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack(spacing: 14) {
                    Text(verbatim: country.flag)
                        .font(.system(size: 44))
                        .frame(width: 72, height: 72)
                        .glassCard(cornerRadius: 22)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 4) {
                        ContentText(country.name)
                            .font(.largeTitle.weight(.bold))
                            .fontDesign(.rounded)
                        Text(CountryRegion.title(country.region))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .staggeredAppear(0)

                if highlights.isEmpty {
                    Callout(.info, LocalizedText([
                        "fr": "Pas encore de fiche détaillée pour ce pays. Les liens ci-dessous mènent aux informations à jour du ministère des Affaires étrangères et des organismes concernés.",
                        "en": "No detailed guide for this country yet. The links below lead to up-to-date information from the French Ministry for Foreign Affairs and the relevant bodies.",
                    ]))
                } else {
                    ForEach(Array(highlights.enumerated()), id: \.offset) { index, highlight in
                        HighlightCard(highlight: highlight)
                            .staggeredAppear(index + 1)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Liens utiles")
                        .font(.headline)
                    ForEach(country.links, id: \.url) { ExternalLinkLabel(link: $0) }
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassCard(cornerRadius: 22)

                if store.entry(id: "expatriation") != nil {
                    PrimaryActionButton(title: "Préparer mon départ", symbol: "checklist") {
                        router.path.append(.intro("expatriation"))
                    }
                    .padding(.horizontal, -20)
                }

                IndependentServiceNotice()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct HighlightCard: View {
    let highlight: CountryHighlight
    @Environment(ContentStore.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ContentText(highlight.title)
                .font(.headline)
            ContentText(highlight.body)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            SourcesList(sources: store.countries?.sources(for: highlight.sources) ?? [])
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 20)
    }
}
