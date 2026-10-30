import SwiftUI

/// Contenu d'une orientation : explication, pistes, contacts et courriers.
/// Utilisé en plein écran dans le questionnaire et en carte dans la liste de pièces.
struct OutcomeContent: View {
    let procedure: Procedure
    let outcome: Outcome

    @Environment(ContentStore.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                ContentText(outcome.title)
                    .font(.title2.weight(.bold))
                    .fixedSize(horizontal: false, vertical: true)
                ContentText(outcome.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let actions = outcome.actions, !actions.isEmpty {
                section("Ce que vous pouvez faire") {
                    ForEach(Array(actions.enumerated()), id: \.offset) { _, action in
                        ActionCard(action: action)
                    }
                }
            }

            let contacts = store.help?.contacts(for: outcome.contacts) ?? []
            if !contacts.isEmpty {
                section("Qui peut vous aider") {
                    ForEach(contacts) { ContactCard(contact: $0) }
                }
            }

            let letters = store.help?.letters(for: outcome.letters) ?? []
            if !letters.isEmpty {
                section("Préparer un courrier") {
                    ForEach(letters) { LetterButton(letter: $0, procedure: procedure) }
                }
            }

            SourcesList(sources: procedure.sources(for: outcome.sources))
        }
    }

    private func section(_ title: LocalizedStringKey, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            content()
        }
    }
}

/// Une piste concrète proposée par une orientation.
private struct ActionCard: View {
    let action: OutcomeAction

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ContentText(action.title)
                .font(.body.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
            if let body = action.body {
                ContentText(body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let link = action.link {
                ExternalLinkLabel(link: link)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 18)
    }
}
