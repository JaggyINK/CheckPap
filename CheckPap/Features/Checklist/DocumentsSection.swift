import SwiftUI

/// Pièces à fournir, regroupées par catégorie, puis les pièces retirées (que l'on peut remettre).
struct DocumentsSection: View {
    let procedure: Procedure
    let documents: [RequiredDocument]
    let dismissed: [RequiredDocument]
    let record: SavedProcedure

    @State private var showDismissed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Touchez une pièce pour voir le détail, et le rond pour la cocher quand elle est prête.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            ForEach(DocumentCategory.group(documents), id: \.category) { group in
                VStack(alignment: .leading, spacing: 10) {
                    Label(DocumentCategory.title(group.category), systemImage: DocumentCategory.symbol(group.category))
                        .font(.headline)
                    ForEach(group.documents) { document in
                        DocumentRow(
                            procedure: procedure, document: document, answers: record.answers,
                            isChecked: record.isChecked(document.id),
                            toggle: { withAnimation(.spring(duration: 0.35)) { record.toggle(document.id) } },
                            dismiss: { withAnimation(.spring(duration: 0.4)) { record.dismiss(document.id) } }
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                    }
                }
            }

            if !dismissed.isEmpty {
                dismissedSection
            }
        }
    }

    private var dismissedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.snappy) { showDismissed.toggle() }
            } label: {
                HStack {
                    Label("Pièces retirées (\(dismissed.count))", systemImage: "eye.slash")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .rotationEffect(.degrees(showDismissed ? 180 : 0))
                }
                .foregroundStyle(.secondary)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)

            if showDismissed {
                ForEach(dismissed) { document in
                    HStack {
                        ContentText(document.title)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("Remettre") {
                            withAnimation(.spring(duration: 0.4)) { record.restore(document.id) }
                        }
                        .font(.caption.weight(.semibold))
                    }
                    .padding(12)
                    .glassCard(cornerRadius: 14)
                }
            }
        }
    }
}
