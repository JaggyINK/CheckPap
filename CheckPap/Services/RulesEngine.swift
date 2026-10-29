import Foundation

/// Évalue les conditions du JSON. Aucune règle administrative ici :
/// le moteur sait seulement dire si une condition est vraie pour des réponses données.
enum RulesEngine {
    typealias Answers = [String: String]

    static func isSatisfied(_ condition: Condition?, answers: Answers, today: Date = .now) -> Bool {
        guard let condition else { return true }
        switch condition {
        case let .equals(question, value):
            return answers[question] == value
        case let .oneOf(question, values):
            guard let answer = answers[question] else { return false }
            return values.contains(answer)
        case let .daysFromToday(question, min, max):
            guard let days = answers[question].flatMap({ daysFrom(today, to: $0) }) else { return false }
            return days >= (min ?? .min) && days <= (max ?? .max)
        case let .all(conditions):
            return conditions.allSatisfy { isSatisfied($0, answers: answers, today: today) }
        case let .any(conditions):
            return conditions.contains { isSatisfied($0, answers: answers, today: today) }
        case let .not(condition):
            return !isSatisfied(condition, answers: answers, today: today)
        }
    }

    /// Jours entiers entre aujourd'hui et une date `AAAA-MM-JJ` (négatif si la date est passée).
    static func daysFrom(_ today: Date, to dateString: String) -> Int? {
        guard let date = DayDate.parse(dateString) else { return nil }
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: calendar.startOfDay(for: today), to: calendar.startOfDay(for: date)).day
    }

    /// Questions à poser, dans l'ordre, compte tenu des réponses déjà données.
    static func visibleQuestions(in procedure: Procedure, answers: Answers) -> [Question] {
        walk(procedure, answers).visible
    }

    /// Réponses aux seules questions encore visibles (une réponse devenue hors sujet est ignorée).
    static func effectiveAnswers(in procedure: Procedure, answers: Answers) -> Answers {
        walk(procedure, answers).effective
    }

    static func documents(in procedure: Procedure, answers: Answers) -> [RequiredDocument] {
        let effective = effectiveAnswers(in: procedure, answers: answers)
        return procedure.documents.filter { isSatisfied($0.condition, answers: effective) }
    }

    static func steps(in procedure: Procedure, answers: Answers) -> [GuideStep] {
        let effective = effectiveAnswers(in: procedure, answers: answers)
        return procedure.steps.filter { isSatisfied($0.condition, answers: effective) }
    }

    /// Échéances calculées à partir des dates saisies (ex. : date d'expiration du titre).
    static func deadlines(in procedure: Procedure, answers: Answers) -> [(deadline: Deadline, date: Date)] {
        let effective = effectiveAnswers(in: procedure, answers: answers)
        return (procedure.deadlines ?? [])
            .filter { isSatisfied($0.condition, answers: effective) }
            .compactMap { deadline in
                guard let reference = effective[deadline.relativeTo].flatMap({ DayDate.parse($0) }),
                      let date = Calendar.current.date(byAdding: .day, value: deadline.offsetDays, to: reference)
                else { return nil }
                return (deadline, date)
            }
            .sorted { $0.date < $1.date }
    }

    /// Orientations dont la condition est vraie, du type demandé.
    static func outcomes(in procedure: Procedure, answers: Answers, kind: Outcome.Kind) -> [Outcome] {
        let effective = effectiveAnswers(in: procedure, answers: answers)
        return (procedure.outcomes ?? []).filter { $0.kind == kind && isSatisfied($0.condition, answers: effective) }
    }

    /// Première orientation qui arrête le questionnaire, s'il y en a une.
    static func redirect(in procedure: Procedure, answers: Answers) -> Outcome? {
        outcomes(in: procedure, answers: answers, kind: .redirect).first
    }

    /// Réponses qui expliquent pourquoi un élément s'affiche ("parce que vous avez répondu ...").
    /// Liste vide : l'élément est demandé à tout le monde pour cette démarche.
    static func reasons(for condition: Condition?, in procedure: Procedure, answers: Answers) -> [(question: Question, answer: AnswerOption)] {
        guard let condition else { return [] }
        let effective = effectiveAnswers(in: procedure, answers: answers)
        var seen: Set<String> = []
        var answered: [(question: Question, answer: AnswerOption, matches: Bool)] = []
        for reference in condition.references where seen.insert(reference.question).inserted {
            guard let question = procedure.questions.first(where: { $0.id == reference.question }),
                  let value = effective[question.id],
                  let option = question.choices.first(where: { $0.id == value })
            else { continue }
            answered.append((question, option, reference.values.contains(value)))
        }
        // On montre d'abord les réponses qui correspondent directement à la condition.
        let matching = answered.filter(\.matches)
        return (matching.isEmpty ? answered : matching).map { ($0.question, $0.answer) }
    }

    private static func walk(_ procedure: Procedure, _ answers: Answers) -> (visible: [Question], effective: Answers) {
        var visible: [Question] = []
        var effective: Answers = [:]
        for question in procedure.questions where isSatisfied(question.condition, answers: effective) {
            visible.append(question)
            if let answer = answers[question.id] {
                effective[question.id] = answer
            }
        }
        return (visible, effective)
    }
}
