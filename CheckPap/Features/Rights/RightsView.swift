import SwiftUI

/// Onglet "Mes droits" (1 étranger, 1 solution) : d'abord un questionnaire page par page,
/// puis les droits et aides qui peuvent concerner la personne.
struct RightsView: View {
    @Environment(ContentStore.self) private var store
    @State private var answers = RightsProfileStore.load()
    @State private var editing = RightsProfileStore.load().isEmpty

    var body: some View {
        Group {
            if let rights = store.rights {
                if editing {
                    RightsQuestionnaire(questions: rights.profile.questions, initialAnswers: answers) { result in
                        withAnimation(.spring(duration: 0.5)) {
                            answers = result
                            editing = false
                        }
                        RightsProfileStore.save(result)
                    }
                    .transition(.opacity)
                } else {
                    results(rights)
                        .transition(.opacity)
                }
            } else if case .loading = store.state {
                ProgressView()
            } else {
                ContentUnavailableView("Contenu bientôt disponible", systemImage: "hand.raised")
            }
        }
        .background(AppBackground())
        .navigationTitle("Mes droits")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func results(_ rights: RightsContent) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("1 étranger, 1 solution")
                        .font(.largeTitle.weight(.bold))
                    Text("Les droits et aides qui peuvent vous concerner, et où les demander.")
                        .foregroundStyle(.secondary)
                }
                .staggeredAppear(0)

                RightsProfileSummary(questions: rights.profile.questions, answers: answers) {
                    withAnimation(.spring(duration: 0.5)) { editing = true }
                }
                .staggeredAppear(1)

                Callout(.info, LocalizedText([
                    "fr": "Ces informations vous orientent. Seul l'organisme concerné (CAF, Assurance maladie...) peut dire si vous avez droit à une aide. Utilisez son simulateur.",
                    "en": "This information guides you. Only the organisation concerned (CAF, health insurance...) can say whether you are entitled to a benefit. Use its simulator.",
                ]))

                RightsResults(content: rights, answers: answers)

                IndependentServiceNotice()
                    .padding(14)
                    .cardSurface(cornerRadius: 18)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }
}
