import SwiftUI

/// Une question : titre, aide repliable, exemple, puis les réponses possibles.
struct QuestionScreen: View {
    let model: QuestionnaireModel
    let question: Question

    @State private var showHelp = false
    @State private var date = Date()
    @State private var advanceTask: Task<Void, Never>?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ContentText(question.title)
                    .font(.title2.weight(.bold))
                    .fontDesign(.rounded)
                    .fixedSize(horizontal: false, vertical: true)

                if let help = question.help {
                    HelpDisclosure(text: help, isExpanded: $showHelp)
                }
                if let example = question.example {
                    Callout(.example, example)
                }

                answers
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            if question.kind == .date || model.answer(for: question) != nil {
                PrimaryActionButton(title: "Continuer") {
                    if question.kind == .date { model.select(DayDate.format(date)) }
                    goNext()
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear(perform: restoreDate)
        .onDisappear { advanceTask?.cancel() }
    }

    @ViewBuilder
    private var answers: some View {
        switch question.kind {
        case .single, .yesNo:
            VStack(spacing: 10) {
                ForEach(Array(question.choices.enumerated()), id: \.element.id) { index, option in
                    OptionButton(option: option, isSelected: model.answer(for: question) == option.id) {
                        choose(option)
                    }
                    .staggeredAppear(index)
                }
            }
        case .country:
            CountryQuestionPicker(selected: model.answer(for: question)) { code in
                withAnimation(.snappy) { model.select(code) }
                goNext()
            }
        case .date:
            DatePicker("Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding(8)
                .glassCard(cornerRadius: 22)
        }
    }

    /// On laisse voir la coche une fraction de seconde, puis on avance tout seul.
    private func choose(_ option: AnswerOption) {
        withAnimation(.snappy) { model.select(option.id) }
        advanceTask?.cancel()
        advanceTask = Task {
            try? await Task.sleep(for: .milliseconds(380))
            guard !Task.isCancelled else { return }
            goNext()
        }
    }

    private func goNext() {
        withAnimation(.spring(duration: 0.45)) { model.next() }
    }

    private func restoreDate() {
        if question.kind == .date, let value = model.answer(for: question), let parsed = DayDate.parse(value) {
            date = parsed
        }
    }
}
