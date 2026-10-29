import SwiftUI

/// "Informations vérifiées le ..." affiché sur chaque fiche.
struct LastVerifiedLabel: View {
    let dateString: String
    @Environment(\.locale) private var locale

    var body: some View {
        if let date = DayDate.parse(dateString) {
            Label {
                Text("Informations vérifiées le \(date.formatted(.dateTime.day().month(.wide).year().locale(locale)))")
            } icon: {
                Image(systemName: "checkmark.seal")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }
}
