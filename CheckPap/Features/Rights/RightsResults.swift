import SwiftUI

/// Droits qui peuvent concerner la personne, regroupés par thème.
struct RightsResults: View {
    let content: RightsContent
    let answers: [String: String]

    private var matching: [RightItem] {
        let effective = RulesEngine.effectiveAnswers(content.profile.questions, answers: answers)
        return content.rights.filter { RulesEngine.isSatisfied($0.condition, answers: effective) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("\(matching.count) droits et aides peuvent vous concerner")
                .font(.title3.weight(.bold))
                .contentTransition(.numericText(value: Double(matching.count)))
                .animation(.snappy, value: matching.count)

            ForEach(RightCategory.group(matching), id: \.category) { group in
                VStack(alignment: .leading, spacing: 10) {
                    Label(RightCategory.title(group.category), systemImage: RightCategory.symbol(group.category))
                        .font(.headline)
                    ForEach(group.rights) { right in
                        RightCard(right: right, content: content)
                            .transition(.opacity.combined(with: .scale(scale: 0.97)))
                    }
                }
            }
        }
        .animation(.spring(duration: 0.4), value: matching.map(\.id))
    }
}
