import SwiftUI

/// Corps de la liste : calcule ce qui concerne la personne, puis affiche l'onglet choisi.
struct ChecklistContent: View {
    let procedure: Procedure
    let record: SavedProcedure
    @Binding var tab: ChecklistTab

    var body: some View {
        let answers = record.answers
        let allDocuments = RulesEngine.documents(in: procedure, answers: answers)
        let documents = allDocuments.filter { !record.isDismissed($0.id) }
        let dismissed = allDocuments.filter { record.isDismissed($0.id) }
        let steps = RulesEngine.steps(in: procedure, answers: answers)
        let deadlines = RulesEngine.deadlines(in: procedure, answers: answers)
        let warnings = RulesEngine.outcomes(in: procedure, answers: answers, kind: .redirect)
            + RulesEngine.outcomes(in: procedure, answers: answers, kind: .warning)
        let done = documents.filter { record.isChecked($0.id) }.count
        let appointments = RulesEngine.appointments(in: procedure, answers: answers)
        let isReady = !documents.isEmpty && done == documents.count

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProgressHeader(procedure: procedure, done: done, total: documents.count)
                    .staggeredAppear(0)

                if isReady && !appointments.isEmpty {
                    ReadyBanner(procedure: procedure, appointments: appointments)
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }

                if !warnings.isEmpty {
                    WarningsSection(procedure: procedure, outcomes: warnings)
                }

                Picker("Affichage", selection: $tab.animation(.snappy)) {
                    Text("Pièces").tag(ChecklistTab.documents)
                    Text("Étapes").tag(ChecklistTab.steps)
                    if !deadlines.isEmpty {
                        Text("Dates").tag(ChecklistTab.dates)
                    }
                }
                .pickerStyle(.segmented)

                switch tab {
                case .documents:
                    DocumentsSection(procedure: procedure, documents: documents, dismissed: dismissed, record: record)
                        .transition(.opacity)
                case .steps:
                    VStack(alignment: .leading, spacing: 24) {
                        if !appointments.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Où déposer votre dossier")
                                    .font(.headline)
                                AppointmentSection(procedure: procedure, appointments: appointments)
                                PlannedAppointmentSection(procedure: procedure)
                            }
                        }
                        StepsTimeline(procedure: procedure, steps: steps, record: record)
                    }
                    .transition(.opacity)
                case .dates:
                    DatesSection(procedure: procedure, deadlines: deadlines)
                        .transition(.opacity)
                }

                VStack(alignment: .leading, spacing: 8) {
                    LastVerifiedLabel(dateString: procedure.lastVerified)
                    IndependentServiceNotice()
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .animation(.spring(duration: 0.5), value: isReady)
    }
}
