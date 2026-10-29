import Observation

/// Écrans de l'app, comme des routes typées.
enum Route: Hashable {
    case category(String)
    case intro(String)
    case questionnaire(String)
    case checklist(String)
    case countries
    case country(String)
}

/// Pile de navigation d'un onglet : n'importe quel écran peut avancer, reculer ou revenir au début.
@Observable
final class Router {
    var path: [Route] = []
}
