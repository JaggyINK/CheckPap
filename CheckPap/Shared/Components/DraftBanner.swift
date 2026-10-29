import SwiftUI

/// Bandeau affiché tant que le contenu d'une démarche n'a pas été relu par un humain.
struct DraftBanner: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.bubble")
                .font(.title3)
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text("Contenu en cours de vérification")
                    .font(.subheadline.weight(.semibold))
                Text("Ces informations ont été rassemblées depuis les sites de l'administration et sont en cours de relecture. Vérifiez toujours auprès de votre préfecture.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 18)
        .accessibilityElement(children: .combine)
    }
}
