import SwiftUI

/// Onglet "Mes droits" (1 étranger 1 solution) : un profil rapide,
/// puis les droits et aides qui peuvent concerner la personne, mis à jour en direct.
struct RightsView: View {
    @Environment(ContentStore.self) private var store
    @State private var answers = RightsProfileStore.load()
    @State private var profileExpanded = RightsProfileStore.load().isEmpty

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("1 étranger, 1 solution")
                        .font(.largeTitle.weight(.bold))
                        .fontDesign(.rounded)
                    Text("Répondez à quelques questions : nous vous montrons les droits et aides qui peuvent vous concerner, et où les demander.")
                        .foregroundStyle(.secondary)
                }
                .staggeredAppear(0)

                if let rights = store.rights {
                    RightsProfileCard(questions: rights.profile.questions, answers: $answers, expanded: $profileExpanded)
                    Callout(.info, LocalizedText([
                        "fr": "Ces informations vous orientent. Seul l'organisme concerné (CAF, Assurance maladie...) peut dire si vous avez droit à une aide. Utilisez son simulateur.",
                        "en": "This information guides you. Only the organisation concerned (CAF, health insurance...) can say whether you are entitled to a benefit. Use its simulator.",
                    ]))
                    RightsResults(content: rights, answers: answers)
                } else if case .loading = store.state {
                    ProgressView().frame(maxWidth: .infinity).padding(.vertical, 40)
                } else {
                    ContentUnavailableView("Contenu bientôt disponible", systemImage: "hand.raised")
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
        .navigationTitle("Mes droits")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: answers) { RightsProfileStore.save(answers) }
    }
}
