import SwiftUI

/// Corps de la liste : calcule ce qui concerne la personne, puis affiche l'onglet choisi.
struct ChecklistContent: View {
    let procedure: Procedure
    let record: SavedProcedure
    @Binding var tab: ChecklistTab

    var body: some View {
        let answers = record.answers
        let documents = RulesEngine.documents(in: procedure, answers: answers)
        let steps = RulesEngine.steps(in: procedure, answers: answers)
        let deadlines = RulesEngine.deadlines(in: procedure, answers: answers)
        let warnings = RulesEngine.outcomes(in: procedure, answers: answers, kind: .redirect)
            + RulesEngine.outcomes(in: procedure, answers: answers, kind: .warning)
        let done = documents.filter { record.isChecked($0.id) }.count

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProgressHeader(procedure: procedure, done: done, total: documents.count)
                    .staggeredAppear(0)

                if procedure.isDraft {
                    DraftBanner()
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
                    DocumentsSection(procedure: procedure, documents: documents, record: record)
                        .transition(.opacity)
                case .steps:
                    StepsTimeline(procedure: procedure, steps: steps)
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
    }
}
