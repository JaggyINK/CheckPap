import SwiftUI

/// Libellé d'une catégorie d'actualité : celles du catalogue, plus "Droits et aides".
enum NewsCategory {
    static let rights = "rights"

    static func title(_ id: String, store: ContentStore) -> Text {
        if id == rights { return Text("Droits et aides") }
        if let category = store.catalog?.categories?.first(where: { $0.id == id }) {
            return Text(verbatim: category.title.resolved(.current))
        }
        return Text("Autres")
    }

    static func symbol(_ id: String, store: ContentStore) -> String {
        if id == rights { return "hand.raised" }
        return store.catalog?.categories?.first { $0.id == id }?.symbol ?? "newspaper"
    }
}
