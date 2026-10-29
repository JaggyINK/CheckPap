import Foundation
import Observation

/// Logique du questionnaire, séparée de l'affichage (comme un hook `useQuestionnaire()` en React).
@Observable
final class QuestionnaireModel {
    let procedure: Procedure
    var answers: [String: String] = [:]
    private(set) var index = 0
    private(set) var isReviewing = false
    /// Orientation affichée à la place de la question suivante (situation non couverte par la démarche).
    private(set) var outcome: Outcome?
    /// Sens de la dernière navigation, pour animer l'entrée de la question depuis le bon côté.
    private(set) var movingForward = true

    init(procedure: Procedure) {
        self.procedure = procedure
    }

    var visibleQuestions: [Question] {
        RulesEngine.visibleQuestions(in: procedure, answers: answers)
    }

    var current: Question? {
        let questions = visibleQuestions
        return index < questions.count ? questions[index] : nil
    }

    var progress: Double {
        let total = visibleQuestions.count
        guard total > 0 else { return 0 }
        return isReviewing ? 1 : Double(index) / Double(total)
    }

    var canGoBack: Bool {
        outcome != nil || isReviewing || index > 0
    }

    func answer(for question: Question) -> String? {
        answers[question.id]
    }

    func select(_ value: String) {
        guard let current else { return }
        answers[current.id] = value
        // Une réponse peut rendre d'autres questions hors sujet : on retire leurs réponses.
        answers = RulesEngine.effectiveAnswers(in: procedure, answers: answers)
    }

    func next() {
        movingForward = true
        if let redirect = RulesEngine.redirect(in: procedure, answers: answers) {
            outcome = redirect
            return
        }
        if index + 1 < visibleQuestions.count {
            index += 1
        } else {
            isReviewing = true
        }
    }

    func back() {
        movingForward = false
        if outcome != nil {
            outcome = nil
        } else if isReviewing {
            isReviewing = false
            index = max(visibleQuestions.count - 1, 0)
        } else if index > 0 {
            index -= 1
        }
    }

    /// Reprise de réponses déjà enregistrées : on ouvre directement le récapitulatif.
    func resume(with saved: [String: String]) {
        answers = RulesEngine.effectiveAnswers(in: procedure, answers: saved)
        isReviewing = true
        outcome = nil
    }

    func edit(_ question: Question) {
        guard let position = visibleQuestions.firstIndex(of: question) else { return }
        movingForward = false
        index = position
        isReviewing = false
        outcome = nil
    }

    /// Texte de la réponse donnée, pour le récapitulatif.
    func answerLabel(for question: Question, locale: Locale) -> String? {
        guard let value = answers[question.id] else { return nil }
        switch question.kind {
        case .single, .yesNo:
            return question.choices.first { $0.id == value }?.label.resolved(locale)
        case .date:
            return DayDate.parse(value)?.formatted(.dateTime.day().month(.wide).year().locale(locale))
        }
    }
}
