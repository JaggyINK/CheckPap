import SwiftUI

/// "Les plus demandées" : accès direct aux démarches mises en avant dans le catalogue.
struct FeaturedSection: View {
    @Environment(ContentStore.self) private var store

    var body: some View {
        let entries = (store.catalog?.featured ?? []).compactMap { store.entry(id: $0) }
        if !entries.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Les plus demandées")
                    .font(.headline)
                ForEach(entries) { ProcedureCard(entry: $0) }
            }
        }
    }
}
