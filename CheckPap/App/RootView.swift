import SwiftUI

/// Vue racine. Pour l'instant, un écran d'accueil provisoire
/// qui sert à valider le style visuel (Liquid Glass) de l'app.
struct RootView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    upcomingCard
                    IndependentServiceNotice()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(AppBackground())
            .navigationTitle("Check Pap")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Vos démarches, une étape à la fois.")
                .font(.title.bold())
            Text("Choisissez votre situation, répondez à quelques questions et retrouvez les pièces demandées par la préfecture.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var upcomingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("En préparation", systemImage: "hammer")
                .font(.headline)
            Text("La liste des démarches arrive bientôt.")
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
    }
}

#Preview("Français") {
    RootView()
        .environment(\.locale, Locale(identifier: "fr"))
}

#Preview("English") {
    RootView()
        .environment(\.locale, Locale(identifier: "en"))
}
