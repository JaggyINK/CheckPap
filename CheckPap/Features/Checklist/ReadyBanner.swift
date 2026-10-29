import SwiftUI

/// Affiché quand toutes les pièces sont cochées : félicitations, puis l'étape suivante.
struct ReadyBanner: View {
    let procedure: Procedure
    let appointments: [Appointment]
    @State private var celebrate = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(systemName: "party.popper.fill")
                    .font(.title)
                    .foregroundStyle(Brand.teal)
                    .symbolEffect(.bounce, value: celebrate)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Votre dossier est prêt !")
                        .font(.title3.weight(.bold))
                        .fontDesign(.rounded)
                    Text("Prochaine étape : déposer votre demande ou prendre rendez-vous.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            AppointmentSection(procedure: procedure, appointments: appointments)
            PlannedAppointmentSection(procedure: procedure)
        }
        .padding(18)
        .background(Brand.mint.opacity(0.14), in: .rect(cornerRadius: 26, style: .continuous))
        .onAppear { celebrate.toggle() }
    }
}
