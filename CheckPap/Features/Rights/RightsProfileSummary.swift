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
                    .secondaryButton()
            }
            Text(verbatim: labels.joined(separator: " · "))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 22)
    }
}
