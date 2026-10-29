import SwiftUI

/// Étapes guidées, en frise numérotée : avant, pendant et après le dépôt.
struct StepsTimeline: View {
    let procedure: Procedure
    let steps: [GuideStep]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(GuideStep.Phase.allCases, id: \.self) { phase in
                let phaseSteps = steps.filter { $0.phase == phase }
                if !phaseSteps.isEmpty {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(title(for: phase))
                            .font(.headline)
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(phaseSteps.enumerated()), id: \.element.id) { index, step in
                                StepRow(procedure: procedure, step: step, number: index + 1,
                                        isLast: index == phaseSteps.count - 1)
                                    .staggeredAppear(index)
                            }
                        }
                        .padding(18)
                        .glassCard(cornerRadius: 22)
                    }
                }
            }
        }
    }

    private func title(for phase: GuideStep.Phase) -> LocalizedStringKey {
        switch phase {
        case .before: "Avant de déposer"
        case .submit: "Le dépôt"
        case .after: "Après le dépôt"
        }
    }
}
