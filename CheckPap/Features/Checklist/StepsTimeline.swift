import SwiftUI

/// Étapes guidées, en frise numérotée : avant, pendant et après le dépôt.
/// Les étapes faites sont cochées, l'étape en cours est mise en avant, les suivantes sont grisées.
struct StepsTimeline: View {
    let procedure: Procedure
    let steps: [GuideStep]
    let record: SavedProcedure

    /// Ordre réel : avant, dépôt, après.
    private var ordered: [GuideStep] {
        GuideStep.Phase.allCases.flatMap { phase in steps.filter { $0.phase == phase } }
    }

    private var currentId: String? {
        ordered.first { !record.isCompleted(step: $0.id) }?.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Touchez le numéro d'une étape quand elle est faite.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            ForEach(GuideStep.Phase.allCases, id: \.self) { phase in
                let phaseSteps = ordered.filter { $0.phase == phase }
                if !phaseSteps.isEmpty {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(title(for: phase))
                            .font(.headline)
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(phaseSteps.enumerated()), id: \.element.id) { index, step in
                                StepRow(
                                    procedure: procedure, step: step, number: index + 1,
                                    isLast: index == phaseSteps.count - 1,
                                    state: state(of: step),
                                    toggle: { withAnimation(.spring(duration: 0.35)) { record.toggle(step: step.id) } }
                                )
                                .staggeredAppear(index)
                            }
                        }
                        .padding(18)
                        .cardSurface(cornerRadius: 22)
                    }
                }
            }
        }
    }

    private func state(of step: GuideStep) -> StepRow.State {
        if record.isCompleted(step: step.id) { return .done }
        return step.id == currentId ? .current : .upcoming
    }

    private func title(for phase: GuideStep.Phase) -> LocalizedStringKey {
        switch phase {
        case .before: "Avant de déposer"
        case .submit: "Le dépôt"
        case .after: "Après le dépôt"
        }
    }
}
