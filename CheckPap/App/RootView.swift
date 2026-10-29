import SwiftUI

/// Vue racine : quatre onglets, chacun avec sa propre pile de navigation.
struct RootView: View {
    /// Onglet de départ. On peut le forcer au lancement (captures d'écran, tests) :
    /// `xcrun simctl launch <appareil> <bundle-id> -initialTab rights`
    @State private var tab = AppTab(rawValue: UserDefaults.standard.string(forKey: "initialTab") ?? "") ?? .news

    var body: some View {
        // `.tabItem` fonctionne dès iOS 17 ; sur iOS 26, la barre d'onglets prend l'effet Liquid Glass.
        TabView(selection: $tab) {
            NavigationTab { NewsView() }
                .tabItem { Label("Actualités", systemImage: "newspaper") }
                .tag(AppTab.news)
            NavigationTab { ProceduresView() }
                .tabItem { Label("Démarches", systemImage: "square.grid.2x2") }
                .tag(AppTab.procedures)
            NavigationTab { RightsView() }
                .tabItem { Label("Mes droits", systemImage: "hand.raised") }
                .tag(AppTab.rights)
            NavigationTab { MyFilesView(onBrowse: { tab = .procedures }) }
                .tabItem { Label("Mes dossiers", systemImage: "tray.full") }
                .tag(AppTab.files)
        }
    }
}

enum AppTab: String, Hashable {
    case news, procedures, rights, files
}

/// Une pile de navigation indépendante, avec son propre `Router`.
private struct NavigationTab<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @State private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: Route.self) { RouteDestination(route: $0) }
        }
        .environment(router)
    }
}
