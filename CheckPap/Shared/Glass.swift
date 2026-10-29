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

/// Fond de l'app : un dégradé doux menthe et sarcelle en haut, qui se fond dans le fond système.
/// Le verre a besoin de couleurs derrière lui pour être visible.
struct AppBackground: View {
    var body: some View {
        Group {
            if #available(iOS 18.0, *) {
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.45], [0.6, 0.35], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1],
                    ],
                    colors: [
                        Brand.mint.opacity(0.45), Brand.teal.opacity(0.30), Brand.mint.opacity(0.25),
                        Brand.mint.opacity(0.15), Color(.systemBackground), Brand.teal.opacity(0.12),
                        Color(.systemBackground), Color(.systemBackground), Brand.mint.opacity(0.10),
                    ]
                )
            } else {
                LinearGradient(
                    colors: [Brand.mint.opacity(0.35), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .center
                )
            }
        }
        .ignoresSafeArea()
    }
}
