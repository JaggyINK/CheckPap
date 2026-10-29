import Observation

/// Écrans de l'app, comme des routes typées.
enum Route: Hashable {
    case intro(String)
    case questionnaire(String)
    case checklist(String)
}

/// Pile de navigation partagée : n'importe quel écran peut avancer, reculer ou revenir à l'accueil.
@Observable
final class Router {
    var path: [Route] = []
}
