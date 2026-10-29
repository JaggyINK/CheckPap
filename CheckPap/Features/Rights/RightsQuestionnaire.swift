import SwiftUI

/// Profil de "Mes droits", une question par écran (même affichage que les démarches).
struct RightsQuestionnaire: View {
    let questions: [Question]
    let initialAnswers: [String: String]
    let onFinish: ([String: String]) -> Void

    @State private var model: QuestionnaireModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(questions: [Question], initialAnswers: [String: String], onFinish: @escaping ([String: String]) -> Void) {
        self.questions = questions
        self.initialAnswers = initialAnswers
        self.onFinish = onFinish
        let model = QuestionnaireModel(questions: questions)
        model.restart(with: initialAnswers)
        _model = State(initialValue: model)
    }

    var body: some View {
        VStack(spacing: 0) {
            QuestionnaireHeader(title: LocalizedText(["fr": "Votre profil", "en": "Your profile"]), model: model)
            ZStack {
                if let question = model.current {
                    QuestionScreen(model: model, question: question)
                        .id(question.id)
                        .transition(slide)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .toolbar {
            if model.canGoBack {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation(.spring(duration: 0.45)) { model.back() }
                    } label: {
                        Label("Précédent", systemImage: "chevron.backward")
                    }
                }
            }
        }
        .onChange(of: model.isReviewing) { _, finished in
            if finished { onFinish(model.answers) }
        }
    }

    private var slide: AnyTransition {
        if reduceMotion { return .opacity }
        return .asymmetric(
            insertion: .move(edge: model.movingForward ? .trailing : .leading).combined(with: .opacity),
            removal: .move(edge: model.movingForward ? .leading : .trailing).combined(with: .opacity)
        )
    }
}
