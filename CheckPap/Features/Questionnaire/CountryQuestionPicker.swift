import SwiftUI

/// Réponse à une question "pays" : champ de recherche et liste des pays.
struct CountryQuestionPicker: View {
    let selected: String?
    let onSelect: (String) -> Void

    @Environment(ContentStore.self) private var store
    @Environment(\.locale) private var locale
    @State private var query = ""

    private var countries: [Country] {
        let all = store.countries?.list.countries ?? []
        let needle = ProcedureSearch.normalize(query)
        let matching = needle.isEmpty ? all : all.filter { country in
            country.name.values.values.contains { ProcedureSearch.normalize($0).contains(needle) }
        }
        return matching.sorted { $0.name.resolved(locale).localizedCompare($1.name.resolved(locale)) == .orderedAscending }
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Rechercher un pays", text: $query)
                    .autocorrectionDisabled()
            }
            .padding(12)
            .glassCard(cornerRadius: 14)

            LazyVStack(spacing: 8) {
                ForEach(countries.prefix(query.isEmpty ? 40 : 200)) { country in
                    Button {
                        onSelect(country.id)
                    } label: {
                        HStack(spacing: 12) {
                            Text(verbatim: country.flag).font(.title3)
                            ContentText(country.name)
                                .foregroundStyle(.primary)
                            Spacer()
                            if selected == country.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Brand.teal)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .contentShape(.rect)
                        .glassCard(cornerRadius: 14)
                    }
                    .buttonStyle(PressableButtonStyle())
                }
                if query.isEmpty {
                    Text("Tapez le nom du pays pour le trouver plus vite.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
