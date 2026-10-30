import SwiftUI

/// Choisir un pays : recherche, pays les plus choisis en premier, puis tous les pays par région.
struct CountryListView: View {
    @Environment(ContentStore.self) private var store
    @Environment(\.locale) private var locale
    @State private var query = ""

    var body: some View {
        List {
            if let content = store.countries {
                let countries = filtered(content.list.countries)
                if query.isEmpty {
                    let featured = countries.filter { content.hasDetails($0.id) }
                    if !featured.isEmpty {
                        Section {
                            ForEach(featured) { CountryRow(country: $0, detailed: true) }
                        } header: {
                            Text("Où partent le plus de Français")
                        }
                    }
                    ForEach(CountryRegion.order + ["other"], id: \.self) { region in
                        let inRegion = countries.filter { region == "other" ? !CountryRegion.order.contains($0.region) : $0.region == region }
                        if !inRegion.isEmpty {
                            Section(CountryRegion.title(region)) {
                                ForEach(inRegion) { CountryRow(country: $0, detailed: content.hasDetails($0.id)) }
                            }
                        }
                    }
                } else if countries.isEmpty {
                    ContentUnavailableView.search(text: query)
                } else {
                    ForEach(countries) { CountryRow(country: $0, detailed: content.hasDetails($0.id)) }
                }
            } else {
                ContentUnavailableView("Liste des pays bientôt disponible", systemImage: "globe")
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppBackground())
        .navigationTitle("Choisir un pays")
        .searchable(text: $query, prompt: Text("Rechercher un pays"))
    }

    private func filtered(_ countries: [Country]) -> [Country] {
        let needle = ProcedureSearch.normalize(query)
        let matching = needle.isEmpty ? countries : countries.filter { country in
            country.name.values.values.contains { ProcedureSearch.normalize($0).contains(needle) }
        }
        return matching.sorted { $0.name.resolved(locale).localizedCompare($1.name.resolved(locale)) == .orderedAscending }
    }
}

private struct CountryRow: View {
    let country: Country
    let detailed: Bool
    @Environment(Router.self) private var router

    var body: some View {
        Button {
            router.path.append(.country(country.id))
        } label: {
            HStack(spacing: 12) {
                Text(verbatim: country.flag)
                    .font(.title2)
                    .accessibilityHidden(true)
                ContentText(country.name)
                    .foregroundStyle(.primary)
                Spacer()
                if detailed {
                    Text("Fiche détaillée")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Image(systemName: "chevron.forward")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}
