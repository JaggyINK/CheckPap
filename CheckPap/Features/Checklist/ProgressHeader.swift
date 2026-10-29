import SwiftUI

/// En-tête de la liste : anneau de progression et "3 sur 12 pièces prêtes".
struct ProgressHeader: View {
    let procedure: Procedure
    let done: Int
    let total: Int

    private var progress: Double { Double(done) / Double(max(total, 1)) }
    private var isComplete: Bool { total > 0 && done == total }

    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                ProgressRing(progress: progress, lineWidth: 9)
                if isComplete {
                    Image(systemName: "checkmark")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Brand.teal)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text(verbatim: "\(Int((progress * 100).rounded()))%")
                        .font(.headline.monospacedDigit())
                        .contentTransition(.numericText(value: progress))
                }
            }
            .frame(width: 76, height: 76)
            .animation(.spring(duration: 0.5), value: isComplete)

            VStack(alignment: .leading, spacing: 4) {
                ContentText(procedure.title)
                    .font(.title3.weight(.bold))
                    .fontDesign(.rounded)
                    .fixedSize(horizontal: false, vertical: true)
                if isComplete {
                    Text("Toutes vos pièces sont prêtes.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Brand.teal)
                } else {
                    Text("\(done) sur \(total) pièces prêtes")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .contentTransition(.numericText(value: Double(done)))
                }
            }
            Spacer(minLength: 0)
        }
        .padding(18)
        .glassCard(cornerRadius: 24)
        .sensoryFeedback(.success, trigger: isComplete) { _, complete in complete }
    }
}
