import SwiftUI

/// Code postal de la personne, enregistré une fois et réutilisé partout (préfecture, rendez-vous).
enum UserLocation {
    static let postalCodeKey = "postalCode"
    static let departmentKey = "departmentCode"

    /// Enregistre le code postal et le département correspondant ; renvoie `false` si le code est invalide.
    @discardableResult
    static func save(postalCode: String) -> Bool {
        guard let department = PostalCode.departmentCode(postalCode) else { return false }
        UserDefaults.standard.set(postalCode.filter(\.isNumber), forKey: postalCodeKey)
        UserDefaults.standard.set(department, forKey: departmentKey)
        return true
    }
}
