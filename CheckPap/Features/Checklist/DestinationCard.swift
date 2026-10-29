import SwiftUI

/// "Votre destination" : le pays choisi dans le questionnaire, son budget repère
/// et le lien vers sa fiche complète.
struct DestinationCard: View {
    let countryCode: String

    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router

    var body: some View {
        if let content = store.countries, let country = content.country(id: countryCode) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    router.path.append(.country(country.id))
                } label: {
                    HStack(spacing: 12) {
                        Text(verbatim: country.flag).font(.largeTitle)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Votre destination")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Brand.teal)
                            ContentText(country.name)
                                .font(.title3.weight(.bold))
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Label("Voir la fiche", systemImage: "chevron.forward")
                            .labelStyle(.titleAndIcon)
                            .font(.footnote.weight(.semibold))
                    }
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)

                CountryBudgetCard(country: country, content: content)
            }
        }
    }
}
