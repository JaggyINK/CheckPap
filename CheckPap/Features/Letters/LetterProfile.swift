import Foundation
import SwiftUI

/// Informations saisies pour les courriers, gardées sur le téléphone uniquement
/// pour ne pas les retaper à chaque courrier. Rien n'est envoyé ailleurs.
struct LetterProfile {
    private static let storageKey = "letterProfile"

    var values: [String: String]

    static func load() -> LetterProfile {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let values = try? JSONDecoder().decode([String: String].self, from: data)
        else { return LetterProfile(values: [:]) }
        return LetterProfile(values: values)
    }

    func save() {
        if let data = try? JSONEncoder().encode(values) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }

    static func erase() {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    func binding(for field: LetterField, onChange: @escaping (LetterProfile) -> Void) -> Binding<String> {
        Binding(
            get: { values[field.rawValue] ?? "" },
            set: { newValue in
                var copy = self
                copy.values[field.rawValue] = newValue
                onChange(copy)
            }
        )
    }
}
