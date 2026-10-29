import SwiftUI

/// Une étape de la frise : numéro, trait vertical, explication, lien et courriers utiles.
struct StepRow: View {
    let procedure: Procedure
    let step: GuideStep
    let number: Int
    let isLast: Bool

    @Environment(ContentStore.self) private var store

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                Text(verbatim: "\(number)")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Brand.teal, in: .circle)
                if !isLast {
                    Rectangle()
                        .fill(Brand.mint.opacity(0.45))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                ContentText(step.title)
                    .font(.body.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                ContentText(step.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if let link = step.link {
                    ExternalLinkLabel(link: link)
                }
                ForEach(store.help?.letters(for: step.letters) ?? []) { letter in
                    LetterButton(letter: letter, procedure: procedure)
                }
                SourcesList(sources: procedure.sources(for: step.sources))
            }
            .padding(.bottom, isLast ? 0 : 22)
        }
    }
}
