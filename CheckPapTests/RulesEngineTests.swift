import Foundation
import Testing
@testable import CheckPap

/// Tests du moteur de règles sur une démarche fictive écrite ici (pas le vrai contenu).
struct RulesEngineTests {
    let procedure: Procedure

    init() throws {
        let json = """
        {
          "id": "test", "reviewStatus": "draft", "lastVerified": "2026-10-29",
          "title": {"fr": "Test", "en": "Test"}, "summary": {"fr": "S", "en": "S"},
          "sources": [{"id": "s", "publisher": "service-public.gouv.fr", "title": "T", "url": "https://www.service-public.gouv.fr", "consulted": "2026-10-29"}],
          "questions": [
            {"id": "status", "kind": "single", "title": {"fr": "Q1", "en": "Q1"}, "sources": ["s"],
             "options": [{"id": "student", "label": {"fr": "É", "en": "S"}}, {"id": "worker", "label": {"fr": "S", "en": "W"}}]},
            {"id": "has_job", "kind": "yesNo", "title": {"fr": "Q2", "en": "Q2"}, "sources": ["s"],
             "condition": {"question": "status", "equals": "student"}},
            {"id": "expiry", "kind": "date", "title": {"fr": "Q3", "en": "Q3"}, "sources": ["s"]}
          ],
          "documents": [
            {"id": "passport", "category": "identity", "title": {"fr": "P", "en": "P"}, "details": {"fr": "D", "en": "D"}, "sources": ["s"]},
            {"id": "contract", "category": "work", "title": {"fr": "C", "en": "C"}, "details": {"fr": "D", "en": "D"}, "sources": ["s"],
             "condition": {"all": [{"question": "status", "equals": "student"}, {"question": "has_job", "equals": "yes"}]}},
            {"id": "payslips", "category": "work", "title": {"fr": "B", "en": "B"}, "details": {"fr": "D", "en": "D"}, "sources": ["s"],
             "condition": {"any": [{"question": "status", "in": ["worker"]}, {"question": "has_job", "equals": "yes"}]}},
            {"id": "not_student", "category": "other", "title": {"fr": "N", "en": "N"}, "details": {"fr": "D", "en": "D"}, "sources": ["s"],
             "condition": {"not": {"question": "status", "equals": "student"}}}
          ],
          "steps": [],
          "deadlines": [
            {"id": "start", "relativeTo": "expiry", "offsetDays": -60, "title": {"fr": "T", "en": "T"}, "sources": ["s"]}
          ]
        }
        """
        procedure = try JSONDecoder().decode(Procedure.self, from: Data(json.utf8))
    }

    private func documentIds(_ answers: [String: String]) -> Set<String> {
        Set(RulesEngine.documents(in: procedure, answers: answers).map(\.id))
    }

    @Test func documentWithoutConditionIsAlwaysShown() {
        #expect(documentIds([:]).contains("passport"))
    }

    @Test func conditionalQuestionAppearsOnlyWhenItsConditionIsTrue() {
        let forWorker = RulesEngine.visibleQuestions(in: procedure, answers: ["status": "worker"]).map(\.id)
        let forStudent = RulesEngine.visibleQuestions(in: procedure, answers: ["status": "student"]).map(\.id)
        #expect(forWorker == ["status", "expiry"])
        #expect(forStudent == ["status", "has_job", "expiry"])
    }

    @Test(arguments: [
        (["status": "student", "has_job": "yes"], ["passport", "contract", "payslips"]),
        (["status": "student", "has_job": "no"], ["passport"]),
        (["status": "worker"], ["passport", "payslips", "not_student"]),
        ([:], ["passport", "not_student"]),
    ])
    func documentsMatchAnswers(answers: [String: String], expected: [String]) {
        #expect(documentIds(answers) == Set(expected))
    }

    @Test func answerToHiddenQuestionIsIgnored() {
        // "has_job" a une réponse, mais la question n'est pas posée à un salarié.
        let ids = documentIds(["status": "worker", "has_job": "yes"])
        #expect(!ids.contains("contract"))
        #expect(RulesEngine.effectiveAnswers(in: procedure, answers: ["status": "worker", "has_job": "yes"])["has_job"] == nil)
    }

    @Test func deadlineIsComputedFromDateAnswer() throws {
        let deadlines = RulesEngine.deadlines(in: procedure, answers: ["expiry": "2027-03-01"])
        let first = try #require(deadlines.first)
        #expect(DayDate.format(first.date) == "2026-12-31")
    }

    @Test func yesNoQuestionOffersTwoChoices() throws {
        let question = try #require(procedure.questions.first { $0.id == "has_job" })
        #expect(question.choices.map(\.id) == ["yes", "no"])
    }
}
