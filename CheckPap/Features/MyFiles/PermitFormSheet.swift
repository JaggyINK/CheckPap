import SwiftUI

/// Saisie du titre de séjour : type (questions de la démarche Renouvellement) et date de fin.
struct PermitFormSheet: View {
    let renewal: Procedure
    let initial: PermitInfo?
    let onSave: (PermitInfo) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.locale) private var locale
    @State private var answers: [String: String] = [:]
    @State private var expiry = Calendar.current.date(byAdding: .month, value: 6, to: .now) ?? .now

    /// Seules les questions de type qui sont visibles compte tenu des réponses.
    private var questions: [Question] {
        RulesEngine.visibleQuestions(in: renewal, answers: answers)
            .filter { PermitInfo.typeQuestions.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Fin de validité", selection: $expiry, displayedComponents: .date)
                } header: {
                    Text("Votre titre de séjour")
                } footer: {
                    Text("Cette date est écrite sur votre carte. Si elle est déjà passée, indiquez-la quand même.")
                }
                ForEach(questions) { question in
                    Section {
                        Picker(selection: binding(for: question)) {
                            Text("Choisir").tag("")
                            ForEach(question.choices) { option in
                                Text(verbatim: option.label.resolved(locale)).tag(option.id)
                            }
                        } label: {
                            Text(verbatim: question.title.resolved(locale))
                        }
                        .pickerStyle(.navigationLink)
                    } footer: {
                        if let help = question.help {
                            Text(verbatim: help.resolved(locale))
                        }
                    }
                }
            }
            .navigationTitle("Mon titre de séjour")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        var result = RulesEngine.effectiveAnswers(in: renewal, answers: answers)
                            .filter { PermitInfo.typeQuestions.contains($0.key) }
                        result[PermitInfo.expiryQuestion] = DayDate.format(expiry)
                        onSave(PermitInfo(answers: result))
                        dismiss()
                    }
                }
            }
            .onAppear {
                guard let initial else { return }
                answers = initial.answers
                if let date = initial.expiryDate { expiry = date }
            }
        }
    }

    private func binding(for question: Question) -> Binding<String> {
        Binding(
            get: { answers[question.id] ?? "" },
            set: { value in
                answers[question.id] = value.isEmpty ? nil : value
                answers = RulesEngine.effectiveAnswers(in: renewal, answers: answers)
            }
        )
    }
}
