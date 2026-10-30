import SwiftUI

/// Anneau de progression.
struct ProgressRing: View {
    var progress: Double
    var lineWidth: CGFloat = 8

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemFill), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0.001, min(progress, 1)))
                .stroke(Brand.teal, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .animation(.easeOut(duration: 0.3), value: progress)
        .accessibilityHidden(true)
    }
}
