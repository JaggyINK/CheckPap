import SwiftUI

/// Bouton qui ouvre l'assistant de rédaction d'un courrier.
struct LetterButton: View {
    let letter: LetterTemplate
    let procedure: Procedure

    @State private var isPresented = false

    var body: some View {
        Button {
            isPresented = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: letter.channel == .email ? "envelope" : "envelope.badge.shield.half.filled")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Brand.teal)
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 3) {
                    ContentText(letter.title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                    ContentText(letter.purpose)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                Image(systemName: "chevron.forward")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
            .cardSurface(cornerRadius: 18)
        }
        .buttonStyle(PressableButtonStyle())
        .sheet(isPresented: $isPresented) {
            LetterComposerView(letter: letter, procedure: procedure)
        }
    }
}
