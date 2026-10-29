import Foundation

/// Avancement d'une démarche commencée : pièces prêtes sur pièces demandées.
struct ProcedureProgress {
    let done: Int
    let total: Int

    var fraction: Double { Double(done) / Double(max(total, 1)) }

    static func compute(entryId: String, store: ContentStore, saved: [SavedProcedure]) -> ProcedureProgress? {
        guard let record = saved.first(where: { $0.procedureId == entryId }),
              let procedure = store.procedures[entryId]
        else { return nil }
        let documents = RulesEngine.documents(in: procedure, answers: record.answers).filter { !record.isDismissed($0.id) }
        return ProcedureProgress(done: documents.filter { record.isChecked($0.id) }.count, total: documents.count)
    }
}
