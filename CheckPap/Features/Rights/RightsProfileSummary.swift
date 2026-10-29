import SwiftUI

/// Résumé du profil (réponses données) avec le bouton "Modifier mon profil".
struct RightsProfileSummary: View {
    let questions: [Question]
    let answers: [String: String]
    let onEdit: () -> Void

    @Environment(\.locale) private var locale

    private var labels: [String] {
        RulesEngine.visibleQuestions(questions, answers: answers).compactMap { question in
            guard let value = answers[question.id] else { return nil }
            return question.choices.first { $0.id == value }?.label.resolved(locale)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Votre profil", systemImage: "person.crop.circle")
                    .font(.headline)
                Spacer()
                Button("Modifier", action: onEdit)
                    .font(.subheadline.weight(.semibold))
                    .secondaryGlassButton()
            }
            FlowLayout(spacing: 6) {
                ForEach(labels, id: \.self) { label in
                    Text(verbatim: label)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Brand.mint.opacity(0.18), in: .capsule)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 22)
    }
}
