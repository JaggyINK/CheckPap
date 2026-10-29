import SwiftUI

/// "Pourquoi cette pièce ?" : les réponses qui la rendent nécessaire,
/// ou la mention qu'elle est demandée à tout le monde pour cette démarche.
struct DocumentReason: View {
    let reasons: [(question: Question, answer: AnswerOption)]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Pourquoi cette pièce ?", systemImage: "person.crop.circle.badge.questionmark")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Brand.teal)

            if reasons.isEmpty {
                Text("Demandée à toutes les personnes qui font cette démarche.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                Text("Parce que vous avez répondu :")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                ForEach(reasons, id: \.question.id) { reason in
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Image(systemName: "arrow.turn.down.right")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        VStack(alignment: .leading, spacing: 1) {
                            ContentText(reason.question.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            ContentText(reason.answer.label)
                                .font(.footnote.weight(.semibold))
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Brand.mint.opacity(0.10), in: .rect(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}
