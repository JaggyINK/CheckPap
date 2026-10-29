import Testing
@testable import CheckPap

/// Premier test : vérifie que la cible de test se lance et voit le code de l'app.
/// Les vrais tests (contenu JSON, moteur de règles) arrivent en phase 9.
struct SmokeTests {
    @Test func rootViewCanBeCreated() {
        _ = RootView()
        #expect(Bool(true))
    }
}
