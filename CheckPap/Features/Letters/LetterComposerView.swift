import SwiftUI

/// Assistant de rédaction : la personne remplit ses informations,
/// voit le courrier se compléter en direct, puis le copie, le partage ou l'envoie par e-mail.
struct LetterComposerView: View {
    let letter: LetterTemplate
    let procedure: Procedure

    @Environment(ContentStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var profile = LetterProfile.load()
    @State private var copied = false

    private var values: [String: String] {
        profile.values.merging([
            "today": LetterRenderer.today(),
            "procedure": procedure.title.resolved(Locale(identifier: "fr")),
        ]) { current, _ in current }
    }

    private var subject: String { LetterRenderer.render(letter.subject, values: values) }
    private var letterText: String { LetterRenderer.render(letter.body, values: values) }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ContentText(letter.summary)
                        .font(.subheadline)
                } header: {
                    Text("Ce que dit ce courrier")
                }

                Section {
                    ForEach(LetterField.fields(for: letter), id: \.self) { field in
                        LabeledContent(field.label) {
                            TextField(field.prompt, text: profile.binding(for: field) { profile = $0 })
                                .keyboardType(field.keyboard)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                } header: {
                    Text("Vos informations")
                } footer: {
                    Text("Gardées uniquement sur ce téléphone, pour vos prochains courriers.")
                }

                Section {
                    LetterPreview(subject: subject, text: letterText)
                } header: {
                    Text("Aperçu")
                }

                if let attachments = letter.attachments {
                    Section {
                        ContentText(attachments)
                            .font(.subheadline)
                    } header: {
                        Text("À joindre")
                    }
                }

                Section {
                    ChannelInstructions(channel: letter.channel)
                    SourcesList(sources: store.help?.sources(for: letter.sources) ?? [])
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .navigationTitle(Text(letter.title.resolved(.current)))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbar }
            .onChange(of: profile.values) { profile.save() }
            .sensoryFeedback(.success, trigger: copied)
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Fermer") { dismiss() }
        }
        ToolbarItemGroup(placement: .bottomBar) {
            Button {
                UIPasteboard.general.string = "\(subject)\n\n\(letterText)"
                copied.toggle()
            } label: {
                Label("Copier", systemImage: copied ? "checkmark" : "doc.on.doc")
                    .contentTransition(.symbolEffect(.replace))
            }
            Spacer()
            ShareLink(item: "\(subject)\n\n\(letterText)", subject: Text(subject)) {
                Label("Partager", systemImage: "square.and.arrow.up")
            }
            if letter.channel == .email, let url = MailLink.url(subject: subject, body: letterText) {
                Spacer()
                Link(destination: url) {
                    Label("E-mail", systemImage: "envelope")
                }
            }
        }
    }
}

/// Le courrier tel qu'il sera envoyé.
private struct LetterPreview: View {
    let subject: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(verbatim: subject)
                .font(.subheadline.weight(.semibold))
            Divider()
            Text(verbatim: text)
                .font(.callout)
                .textSelection(.enabled)
        }
        .padding(.vertical, 6)
    }
}

/// Comment envoyer : e-mail, ou lettre recommandée avec avis de réception.
private struct ChannelInstructions: View {
    let channel: LetterTemplate.Channel

    var body: some View {
        switch channel {
        case .email:
            Label("Copiez ce texte dans un e-mail adressé à votre préfecture. L'adresse se trouve sur son site.",
                  systemImage: "envelope")
                .font(.footnote)
        case .registeredMail:
            Label("Imprimez ce courrier, signez-le, et envoyez-le en lettre recommandée avec avis de réception. Gardez une copie et le reçu.",
                  systemImage: "envelope.badge.shield.half.filled")
                .font(.footnote)
        }
    }
}

/// Lien `mailto:` avec objet et texte déjà remplis.
enum MailLink {
    static func url(subject: String, body: String) -> URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body),
        ]
        return components.url
    }
}
