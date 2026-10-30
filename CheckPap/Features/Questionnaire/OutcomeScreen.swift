import SwiftUI

/// Écran affiché quand les réponses montrent que la démarche ne semble pas correspondre :
/// on explique, on oriente, et on propose de modifier la réponse.
struct OutcomeScreen: View {
    let procedure: Procedure
    let outcome: Outcome
    let onBack: () -> Void

    @Environment(Router.self) private var router

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "signpost.right.and.left")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.orange)
                    .symbolEffect(.bounce, value: outcome.id)
                    .frame(width: 72, height: 72)
                    .cardSurface(cornerRadius: 24)
                    .staggeredAppear(0)

                OutcomeContent(procedure: procedure, outcome: outcome)
                    .staggeredAppear(1)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 4) {
                PrimaryActionButton(title: "Modifier ma réponse", symbol: "arrow.uturn.backward", action: onBack)
                Button("Revenir à l'accueil") { router.path = [] }
                    .font(.subheadline.weight(.semibold))
                    .padding(.bottom, 8)
            }
        }
    }
}
