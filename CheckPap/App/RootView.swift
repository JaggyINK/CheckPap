import SwiftUI

/// Vue racine : écran d'accueil.
/// Les démarches affichées ici sont un aperçu provisoire ; elles viendront de `catalog.json` (tâche 4.0).
struct RootView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Wordmark()
                        .padding(.top, 8)
                    hero
                    procedures
                    IndependentServiceNotice()
                        .padding(14)
                        .glassCard(cornerRadius: 18)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .background(AppBackground())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Vos démarches, une étape à la fois.")
                .font(.largeTitle.weight(.bold))
                .fontDesign(.rounded)
            Text("Choisissez votre situation, répondez à quelques questions et retrouvez les pièces demandées par la préfecture.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var procedures: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quelle est votre démarche ?")
                .font(.headline)
            ForEach(ProcedurePreview.samples) { procedure in
                ProcedureCard(procedure: procedure)
            }
        }
    }
}

/// Aperçu provisoire d'une démarche, en attendant le catalogue JSON.
private struct ProcedurePreview: Identifiable {
    let id: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let symbol: String

    static let samples: [ProcedurePreview] = [
        .init(id: "renewal", title: "Renouveler mon titre de séjour",
              subtitle: "Mon titre arrive bientôt à expiration", symbol: "arrow.triangle.2.circlepath"),
        .init(id: "status-change", title: "Changer de statut",
              subtitle: "Par exemple d'étudiant à salarié", symbol: "arrow.left.arrow.right"),
        .init(id: "naturalisation", title: "Demander la nationalité française",
              subtitle: "Naturalisation par décret", symbol: "person.crop.circle.badge.checkmark"),
        .init(id: "duplicate", title: "Remplacer un titre perdu ou volé",
              subtitle: "Demande de duplicata", symbol: "doc.on.doc"),
    ]
}

private struct ProcedureCard: View {
    let procedure: ProcedurePreview

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: procedure.symbol)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Brand.teal)
                .frame(width: 46, height: 46)
                .background(Brand.mint.opacity(0.18), in: .circle)

            VStack(alignment: .leading, spacing: 3) {
                Text(procedure.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(procedure.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.forward")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 22)
        .accessibilityElement(children: .combine)
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
