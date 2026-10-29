import SwiftUI

/// Mention obligatoire, affichée sur les écrans principaux.
/// Un seul composant pour un seul texte à faire valider et traduire.
struct IndependentServiceNotice: View {
    var body: some View {
        Label {
            Text("Service indépendant. Les démarches officielles sont gratuites.")
        } icon: {
            Image(systemName: "info.circle")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    IndependentServiceNotice()
        .padding()
}
