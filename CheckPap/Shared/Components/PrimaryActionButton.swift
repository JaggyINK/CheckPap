import SwiftUI

/// Grand bouton principal en bas d'écran ("Commencer", "Continuer"...).
struct PrimaryActionButton: View {
    let title: LocalizedStringKey
    var symbol: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if let symbol {
                    Label(title, systemImage: symbol)
                } else {
                    Text(title)
                }
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .primaryGlassButton()
        .controlSize(.large)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}
