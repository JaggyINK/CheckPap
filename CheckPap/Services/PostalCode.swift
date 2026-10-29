import Foundation

/// Trouve le département à partir d'un code postal français.
enum PostalCode {
    /// "94000" → "94" ; "20000" → "2A" ; "20200" → "2B" ; "97400" → "974".
    static func departmentCode(_ raw: String) -> String? {
        let digits = raw.filter(\.isNumber)
        guard digits.count == 5, let three = Int(digits.prefix(3)) else { return nil }
        let two = String(digits.prefix(2))
        switch two {
        case "20": return three < 202 ? "2A" : "2B"
        case "97", "98": return String(digits.prefix(3))
        default: return two
        }
    }
}
