import SwiftUI

/// Apparition en cascade : chaque élément arrive un peu après le précédent.
/// Respecte le réglage "Réduire les animations" d'iOS.
struct StaggeredAppear: ViewModifier {
    let index: Int
    @State private var visible = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0)
            .offset(y: visible || reduceMotion ? 0 : 18)
            .onAppear {
                withAnimation(.spring(duration: 0.5, bounce: 0.2).delay(Double(index) * 0.06)) {
                    visible = true
                }
            }
    }
}

extension View {
    func staggeredAppear(_ index: Int) -> some View {
        modifier(StaggeredAppear(index: index))
    }
}
