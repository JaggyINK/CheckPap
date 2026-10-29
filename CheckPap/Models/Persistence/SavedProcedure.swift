import Foundation
import SwiftData

/// Ce que l'utilisateur a fait pour une démarche : ses réponses et les pièces cochées.
/// On ne stocke que des identifiants : les textes restent dans le JSON et peuvent évoluer.
@Model
final class SavedProcedure {
    @Attribute(.unique) var procedureId: String
    var answersData: Data
    var checkedDocumentIds: [String]
    var contentVersion: String
    var createdAt: Date
    var updatedAt: Date

    init(procedureId: String, answers: [String: String], contentVersion: String) {
        self.procedureId = procedureId
        self.answersData = (try? JSONEncoder().encode(answers)) ?? Data()
        self.checkedDocumentIds = []
        self.contentVersion = contentVersion
        self.createdAt = .now
        self.updatedAt = .now
    }

    /// Les réponses, encodées en JSON pour le stockage.
    var answers: [String: String] {
        get { (try? JSONDecoder().decode([String: String].self, from: answersData)) ?? [:] }
        set {
            answersData = (try? JSONEncoder().encode(newValue)) ?? Data()
            updatedAt = .now
        }
    }

    func isChecked(_ documentId: String) -> Bool {
        checkedDocumentIds.contains(documentId)
    }

    func toggle(_ documentId: String) {
        if let index = checkedDocumentIds.firstIndex(of: documentId) {
            checkedDocumentIds.remove(at: index)
        } else {
            checkedDocumentIds.append(documentId)
        }
        updatedAt = .now
    }
}
