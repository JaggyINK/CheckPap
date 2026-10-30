import SwiftUI

/// Présentation d'une démarche avant le questionnaire.
struct ProcedureIntroView: View {
    let procedure: Procedure
    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router
    @State private var iconBounce = false
    @Environment(\.locale) private var locale

    private var symbol: String {
        store.catalog?.procedures.first { $0.id == procedure.id }?.symbol ?? "doc.text"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Image(systemName: symbol)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(Brand.teal)
                    .symbolEffect(.bounce, value: iconBounce)
                    .frame(width: 88, height: 88)
                    .cardSurface(cornerRadius: 28)
                    .staggeredAppear(0)

                VStack(alignment: .leading, spacing: 10) {
                    ContentText(procedure.title)
                        .font(.largeTitle.weight(.bold))
                    ContentText(procedure.summary)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .staggeredAppear(1)

                if !procedure.summary.isAvailable(in: locale) {
                    Callout(.info, LocalizedText([
                        "fr": "Cette démarche n'est pas encore traduite dans votre langue : elle s'affiche en anglais.",
                        "en": "This procedure is not yet translated into your language: it is shown in English.",
                    ]))
                }

                howItWorks
                    .staggeredAppear(2)

                if store.entry(id: procedure.id)?.showsCountries == true {
                    CountryPickerCard()
                        .staggeredAppear(3)
                }

                VStack(alignment: .leading, spacing: 8) {
                    LastVerifiedLabel(dateString: procedure.lastVerified)
                    IndependentServiceNotice()
                }
                .staggeredAppear(4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            PrimaryActionButton(title: "Commencer") {
                router.path.append(.questionnaire(procedure.id))
            }
        }
        .onAppear { iconBounce.toggle() }
    }

    private var howItWorks: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Comment ça marche")
                .font(.headline)
            IntroStep(number: 1, symbol: "questionmark.bubble",
                      title: "Répondez à quelques questions",
                      detail: "\(procedure.questions.count) questions au maximum, une par écran.")
            IntroStep(number: 2, symbol: "checklist",
                      title: "Recevez votre liste de pièces",
                      detail: "Seulement les documents qui vous concernent, avec des exemples.")
            IntroStep(number: 3, symbol: "map",
                      title: "Suivez les étapes",
                      detail: "Où déposer, quand, et ce qui se passe ensuite.")
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 22)
    }
}

private struct IntroStep: View {
    let number: Int
    let symbol: String
    let title: LocalizedStringKey
    let detail: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbol)
                .font(.body.weight(.semibold))
                .foregroundStyle(Brand.teal)
                .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
