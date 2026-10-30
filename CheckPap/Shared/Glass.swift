import SwiftUI

// Surfaces et boutons de l'app, dans le style des apps Apple :
// le verre (Liquid Glass) reste réservé à la barre d'onglets et à la barre de navigation,
// gérées par le système ; le contenu repose sur des surfaces opaques et sobres.

extension View {
    /// Carte de contenu : surface opaque, coins arrondis, fin trait de séparation.
    func cardSurface(cornerRadius: CGFloat = 14) -> some View {
        let radius = min(cornerRadius, 16)
        return background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: radius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(Color(.separator).opacity(0.5), lineWidth: 0.5)
            }
    }

    /// Zone en retrait à l'intérieur d'une carte (exemple, astuce, date...).
    func insetSurface(cornerRadius: CGFloat = 10) -> some View {
        background(Color(.tertiarySystemFill), in: .rect(cornerRadius: cornerRadius, style: .continuous))
    }

    /// Bouton principal : fond plein de la couleur d'accent.
    func primaryButton() -> some View {
        buttonStyle(.borderedProminent)
    }

    /// Bouton secondaire.
    func secondaryButton() -> some View {
        buttonStyle(.bordered)
    }
}

/// Fond de l'app : le fond groupé du système (gris très clair, ou noir en mode sombre).
struct AppBackground: View {
    var body: some View {
        Color(.systemGroupedBackground).ignoresSafeArea()
    }
}
