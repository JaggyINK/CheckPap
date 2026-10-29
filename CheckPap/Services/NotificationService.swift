import Foundation
import UserNotifications

/// Rappels locaux (sans serveur) : la veille et 2 heures avant un rendez-vous.
/// La permission n'est demandée qu'au moment où la personne active un rappel.
enum NotificationService {
    static let offsets: [TimeInterval] = [-24 * 3600, -2 * 3600]

    static func requestAuthorization() async -> Bool {
        (try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])) ?? false
    }

    /// Programme les rappels encore dans le futur ; renvoie leurs identifiants.
    static func schedule(title: String, body: String, at date: Date) async -> [String] {
        var ids: [String] = []
        for offset in offsets {
            let fireDate = date.addingTimeInterval(offset)
            guard fireDate > .now else { continue }
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
            let id = UUID().uuidString
            let request = UNNotificationRequest(
                identifier: id, content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            )
            if (try? await UNUserNotificationCenter.current().add(request)) != nil {
                ids.append(id)
            }
        }
        return ids
    }

    /// Un rappel à 9 h le jour de chaque date (dates passées ignorées).
    static func schedule(_ reminders: [(date: Date, title: String, body: String)]) async -> [String] {
        var ids: [String] = []
        for reminder in reminders {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: reminder.date)
            components.hour = 9
            guard let fireDate = Calendar.current.date(from: components), fireDate > .now else { continue }
            let content = UNMutableNotificationContent()
            content.title = reminder.title
            content.body = reminder.body
            content.sound = .default
            let id = UUID().uuidString
            let request = UNNotificationRequest(
                identifier: id, content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            )
            if (try? await UNUserNotificationCenter.current().add(request)) != nil {
                ids.append(id)
            }
        }
        return ids
    }

    static func cancel(_ ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}
