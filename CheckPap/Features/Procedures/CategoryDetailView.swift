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
                        .cardSurface(cornerRadius: 18)
                    VStack(alignment: .leading, spacing: 4) {
                        ContentText(category.title)
                            .font(.title.weight(.bold))
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
