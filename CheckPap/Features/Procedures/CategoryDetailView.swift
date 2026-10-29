import SwiftUI

/// Une catégorie : ses sous-catégories en sections, chacune avec ses démarches.
struct CategoryDetailView: View {
    let category: ProcedureCategory
    @Environment(ContentStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                HStack(spacing: 14) {
                    Image(systemName: category.symbol)
                        .font(.title.weight(.semibold))
                        .foregroundStyle(Brand.teal)
                        .frame(width: 60, height: 60)
                        .glassCard(cornerRadius: 18)
                    VStack(alignment: .leading, spacing: 4) {
                        ContentText(category.title)
                            .font(.title.weight(.bold))
                            .fontDesign(.rounded)
                        ContentText(category.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .staggeredAppear(0)

                if category.showsCountries == true {
                    CountryPickerCard()
                        .staggeredAppear(1)
                }

                ForEach(Array(category.subcategories.enumerated()), id: \.element.id) { index, subcategory in
                    let entries = store.entries(category: category.id, subcategory: subcategory.id)
                    if !entries.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            ContentText(subcategory.title)
                                .font(.headline)
                            ForEach(entries) { ProcedureCard(entry: $0) }
                        }
                        .staggeredAppear(index + 1)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// "Choisir un pays" : ouvre la liste de tous les pays et leurs fiches.
private struct CountryPickerCard: View {
    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router

    var body: some View {
        Button {
            router.path.append(.countries)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "globe.europe.africa.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(Brand.teal, in: .rect(cornerRadius: 16, style: .continuous))
                VStack(alignment: .leading, spacing: 3) {
                    Text("Choisir un pays")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("\(store.countries?.list.countries.count ?? 0) fiches pays : visas, santé, protection sociale, contacts")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                Image(systemName: "chevron.forward")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
            .glassCard(cornerRadius: 22)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
