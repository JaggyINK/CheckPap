import SwiftUI

/// "Où déposer votre dossier" : chaque lieu possible, et la préfecture de la personne si besoin.
struct AppointmentSection: View {
    let procedure: Procedure
    let appointments: [Appointment]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(appointments) { appointment in
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        ContentText(appointment.title)
                    } icon: {
                        Image(systemName: Self.symbol(appointment.where))
                    }
                    .font(.headline)
                    ContentText(appointment.body)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    if appointment.where == .prefecture {
                        PrefectureCard()
                    }
                    if let link = appointment.link {
                        ExternalLinkLabel(link: link)
                    }
                    SourcesList(sources: procedure.sources(for: appointment.sources))
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardSurface(cornerRadius: 20)
            }
        }
    }

    static func symbol(_ place: Appointment.Place) -> String {
        switch place {
        case .prefecture: "building.columns"
        case .mairie: "building.2"
        case .online: "laptopcomputer"
        case .ofii: "person.2"
        case .taxOffice: "doc.text"
        case .consulate: "globe"
        case .other: "mappin.and.ellipse"
        }
    }
}
