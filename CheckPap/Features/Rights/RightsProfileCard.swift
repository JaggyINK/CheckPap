import SwiftUI

/// "Votre profil" : toutes les questions sur une carte, réponses en pastilles.
/// Repliée, elle résume le nombre de réponses et propose de modifier.
struct RightsProfileCard: View {
    let questions: [Question]
    @Binding var answers: [String: String]
    @Binding var expanded: Bool

    private var visible: [Question] { RulesEngine.visibleQuestions(questions, answers: answers) }
    private var answeredCount: Int { visible.filter { answers[$0.id] != nil }.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                withAnimation(.snappy) { expanded.toggle() }
            } label: {
                HStack {
                    Label("Votre profil", systemImage: "person.crop.circle")
                        .font(.headline)
                    Spacer()
                    Text("\(answeredCount) sur \(visible.count)")
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(Brand.teal)
                        .contentTransition(.numericText())
                    Image(systemName: "chevron.down")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(expanded ? 180 : 0))
                }
                .foregroundStyle(.primary)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)

            if expanded {
                ForEach(visible) { question in
                    VStack(alignment: .leading, spacing: 8) {
                        ContentText(question.title)
                            .font(.subheadline.weight(.semibold))
                        if let help = question.help {
                            ContentText(help)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        FlowLayout(spacing: 8) {
                            ForEach(question.choices) { option in
                                ChoiceChip(title: Text(verbatim: option.label.resolved(.current)),
                                           isSelected: answers[question.id] == option.id) {
                                    select(option.id, for: question)
                                }
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 24)
    }

    private func select(_ value: String, for question: Question) {
        withAnimation(.snappy) {
            answers[question.id] = value
            answers = RulesEngine.effectiveAnswers(questions, answers: answers)
        }
    }
}
