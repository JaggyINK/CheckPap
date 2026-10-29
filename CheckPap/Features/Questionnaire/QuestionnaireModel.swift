import Foundation
import Observation

/// Logique du questionnaire, séparée de l'affichage (comme un hook `useQuestionnaire()` en React).
/// Sert aux démarches et au profil de "Mes droits" : seule la liste de questions change.
@Observable
final class QuestionnaireModel {
    let questions: [Question]
    /// Orientation qui arrête le questionnaire (démarches seulement).
    private let redirect: ([String: String]) -> Outcome?
    var answers: [String: String] = [:]
    private(set) var index = 0
    private(set) var isReviewing = false
    /// Orientation affichée à la place de la question suivante (situation non couverte par la démarche).
    private(set) var outcome: Outcome?
    /// Sens de la dernière navigation, pour animer l'entrée de la question depuis le bon côté.
    private(set) var movingForward = true

    init(questions: [Question], redirect: @escaping ([String: String]) -> Outcome? = { _ in nil }) {
        self.questions = questions
        self.redirect = redirect
    }

    convenience init(procedure: Procedure) {
        self.init(questions: procedure.questions) { RulesEngine.redirect(in: procedure, answers: $0) }
    }

    var visibleQuestions: [Question] {
        RulesEngine.visibleQuestions(questions, answers: answers)
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
        answers = RulesEngine.effectiveAnswers(questions, answers: answers)
    }

    func next() {
        movingForward = true
        if let outcome = redirect(answers) {
            self.outcome = outcome
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
        answers = RulesEngine.effectiveAnswers(questions, answers: saved)
        isReviewing = true
        outcome = nil
    }

    /// Reprendre des réponses existantes en repartant de la première question (modification du profil).
    func restart(with saved: [String: String]) {
        answers = RulesEngine.effectiveAnswers(questions, answers: saved)
        index = 0
        isReviewing = false
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
