import Foundation
import SwiftData

/// Rendez-vous que la personne a obtenu (préfecture, mairie, OFII...), pour une démarche.
@Model
final class PlannedAppointment {
    var procedureId: String
    var date: Date
    var place: String
    var notes: String
    /// Identifiants des rappels programmés, pour pouvoir les annuler.
    var notificationIds: [String] = []
    var createdAt: Date

    init(procedureId: String, date: Date, place: String, notes: String) {
        self.procedureId = procedureId
        self.date = date
        self.place = place
        self.notes = notes
        self.createdAt = .now
    }
}
