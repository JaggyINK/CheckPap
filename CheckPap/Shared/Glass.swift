import SwiftUI

// Liquid Glass n'existe qu'à partir d'iOS 26. L'app vise iOS 17 minimum :
// ces fonctions choisissent l'effet verre quand il est disponible,
// et un matériau translucide classique sinon.

extension View {
    /// Carte en verre : fond Liquid Glass sur iOS 26+, matériau flouté avant.
    @ViewBuilder
    func glassCard(cornerRadius: CGFloat = 24) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self.background(.ultraThinMaterial, in: .rect(cornerRadius: cornerRadius))
        }
    }

    /// Bouton principal : style verre teinté sur iOS 26+, bouton plein avant.
    @ViewBuilder
    func primaryGlassButton() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }

    /// Bouton secondaire : verre clair sur iOS 26+, bouton bordé avant.
    @ViewBuilder
    func secondaryGlassButton() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.bordered)
        }
    }
}

/// Fond discret de l'app : un léger dégradé de la couleur d'accent,
/// pour que l'effet verre ait quelque chose à réfracter.
struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color.accentColor.opacity(0.18), Color(.systemBackground)],
            startPoint: .top,
            endPoint: .center
        )
        .ignoresSafeArea()
    }
}
