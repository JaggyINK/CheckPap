import SwiftUI

/// Récapitulatif des réponses avant de générer la liste. Chaque réponse est modifiable.
struct ReviewScreen: View {
    let model: QuestionnaireModel
    let onFinish: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Vérifiez vos réponses")
                        .font(.title2.weight(.bold))
                    Text("Touchez une réponse pour la modifier.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 0) {
                    ForEach(Array(model.visibleQuestions.enumerated()), id: \.element.id) { index, question in
                        AnswerRow(model: model, question: question)
                        if index < model.visibleQuestions.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .cardSurface(cornerRadius: 22)

                Callout(.info, LocalizedText([
                    "fr": "Cette liste est une aide pour préparer votre dossier. Elle ne remplace pas les informations de votre préfecture.",
                    "en": "This list helps you prepare your application. It does not replace the information from your prefecture.",
                ]))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            PrimaryActionButton(title: "Voir ma liste de pièces", symbol: "checklist", action: onFinish)
        }
    }
}

private struct AnswerRow: View {
    let model: QuestionnaireModel
    let question: Question
    @Environment(\.locale) private var locale
    @Environment(ContentStore.self) private var store

    private var label: String? {
        if question.kind == .country, let code = model.answer(for: question),
           let country = store.countries?.country(id: code) {
            return "\(country.flag) \(country.name.resolved(locale))"
        }
        return model.answerLabel(for: question, locale: locale)
    }

    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.45)) { model.edit(question) }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    ContentText(question.title)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Group {
                        if let label {
                            Text(verbatim: label)
                        } else {
                            Text("Sans réponse")
                        }
                    }
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                Image(systemName: "pencil")
                    .foregroundStyle(Brand.teal)
            }
            .padding(.vertical, 12)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}
