import SwiftData
import SwiftUI

/// Point d'entrée de l'application (équivalent de `main.tsx` en React).
@main
struct CheckPapApp: App {
    @State private var contentStore = ContentStore(repository: BundleContentRepository())
    @State private var router = Router()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(contentStore)
                .environment(router)
                .tint(Brand.teal)
                .task { await contentStore.load() }
        }
        .modelContainer(for: SavedProcedure.self)
    }
}
