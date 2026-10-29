import SwiftData
import SwiftUI

/// Conteneur du questionnaire : en-tête de progression, puis l'écran du moment
/// (une question, une orientation, ou le récapitulatif).
struct QuestionnaireView: View {
    let procedure: Procedure

    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var saved: [SavedProcedure]
    @State private var model: QuestionnaireModel

    init(procedure: Procedure) {
        self.procedure = procedure
        let id = procedure.id
        _saved = Query(filter: #Predicate<SavedProcedure> { $0.procedureId == id })
        _model = State(initialValue: QuestionnaireModel(procedure: procedure))
    }

    var body: some View {
        VStack(spacing: 0) {
            QuestionnaireHeader(title: procedure.title, model: model)
            ZStack {
                if let outcome = model.outcome {
                    OutcomeScreen(procedure: procedure, outcome: outcome, onBack: goBack)
                        .transition(slide)
                } else if model.isReviewing {
                    ReviewScreen(model: model, onFinish: finish)
                        .transition(slide)
                } else if let question = model.current {
                    QuestionScreen(model: model, question: question)
                        .id(question.id)
                        .transition(slide)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .background(AppBackground())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(model.canGoBack)
        .toolbar {
            if model.canGoBack {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: goBack) {
                        Label("Précédent", systemImage: "chevron.backward")
                    }
                }
            }
        }
        .onAppear {
            if let record = saved.first, model.answers.isEmpty {
                model.resume(with: record.answers)
            }
        }
    }

    /// La nouvelle vue arrive du côté où l'on avance, l'ancienne part de l'autre côté.
    private var slide: AnyTransition {
        if reduceMotion { return .opacity }
        return .asymmetric(
            insertion: .move(edge: model.movingForward ? .trailing : .leading).combined(with: .opacity),
            removal: .move(edge: model.movingForward ? .leading : .trailing).combined(with: .opacity)
        )
    }

    private func goBack() {
        withAnimation(.spring(duration: 0.45)) { model.back() }
    }

    private func finish() {
        if let record = saved.first {
            record.answers = model.answers
            record.contentVersion = store.contentVersion
        } else {
            modelContext.insert(SavedProcedure(
                procedureId: procedure.id,
                answers: model.answers,
                contentVersion: store.contentVersion
            ))
        }
        // On remplace la pile : le retour depuis la liste ramène à l'accueil.
        router.path = [.checklist(procedure.id)]
    }
}
