import EventKit
import EventKitUI
import SwiftUI

/// Écran système "Nouvel événement", prérempli. Depuis iOS 17, il s'ouvre sans demander
/// l'accès au calendrier : c'est la personne qui choisit le calendrier et valide.
/// (UIKit enveloppé pour SwiftUI, comme une librairie non React dans un composant.)
struct AddToCalendarSheet: UIViewControllerRepresentable {
    let title: String
    let date: Date
    let location: String
    let notes: String
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let store = EKEventStore()
        let event = EKEvent(eventStore: store)
        event.title = title
        event.startDate = date
        event.endDate = date.addingTimeInterval(3600)
        event.location = location
        event.notes = notes
        let controller = EKEventEditViewController()
        controller.eventStore = store
        controller.event = event
        controller.editViewDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: EKEventEditViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator { dismiss() }
    }

    final class Coordinator: NSObject, EKEventEditViewDelegate {
        let onFinish: () -> Void

        init(onFinish: @escaping () -> Void) {
            self.onFinish = onFinish
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            onFinish()
        }
    }
}
