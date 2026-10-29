import SwiftUI

/// En-tête du questionnaire : nom de la démarche, "Question 2 sur 7", barre de progression.
struct QuestionnaireHeader: View {
    let title: LocalizedText
    let model: QuestionnaireModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ContentText(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Spacer()
                status
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundStyle(Brand.teal)
            }
            ProgressView(value: model.progress)
                .tint(Brand.teal)
                .animation(.spring(duration: 0.5), value: model.progress)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var status: some View {
        if model.outcome != nil {
            Text("Orientation")
        } else if model.isReviewing {
            Text("Récapitulatif")
        } else {
            Text("Question \(model.index + 1) sur \(model.visibleQuestions.count)")
                .contentTransition(.numericText())
        }
    }
}
