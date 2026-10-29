import SwiftUI

/// Anneau de progression animé.
struct ProgressRing: View {
    var progress: Double
    var lineWidth: CGFloat = 8

    var body: some View {
        ZStack {
            Circle()
                .stroke(Brand.mint.opacity(0.22), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0.001, min(progress, 1)))
                .stroke(
                    AngularGradient(colors: [Brand.mint, Brand.teal, Brand.mint], center: .center),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .animation(.spring(duration: 0.7, bounce: 0.25), value: progress)
        .accessibilityHidden(true)
    }
}
