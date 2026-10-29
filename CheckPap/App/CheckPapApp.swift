import SwiftData
import SwiftUI

/// Point d'entrée de l'application (équivalent de `main.tsx` en React).
@main
struct CheckPapApp: App {
    @State private var contentStore = ContentStore(repository: BundleContentRepository())
    @State private var router = Router()
    @AppStorage(AppLanguage.storageKey) private var language = AppLanguage.system.rawValue
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    private var appLocale: Locale {
        AppLanguage(rawValue: language)?.locale ?? .current
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    RootView()
                        .transition(.opacity)
                } else {
                    OnboardingView { withAnimation(.easeInOut(duration: 0.4)) { hasCompletedOnboarding = true } }
                        .transition(.opacity)
                }
            }
                .environment(\.locale, appLocale)
                .environment(\.layoutDirection, AppLanguage.isRightToLeft(appLocale) ? .rightToLeft : .leftToRight)
                .environment(contentStore)
                .environment(router)
                .tint(Brand.teal)
                .task { await contentStore.load() }
        }
        .modelContainer(for: [SavedProcedure.self, PlannedAppointment.self])
    }
}
