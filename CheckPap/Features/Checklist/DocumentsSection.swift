import SwiftUI

/// Pièces à fournir, regroupées par catégorie.
struct DocumentsSection: View {
    let procedure: Procedure
    let documents: [RequiredDocument]
    let record: SavedProcedure

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
                        DocumentRow(procedure: procedure, document: document, answers: record.answers,
                                    isChecked: record.isChecked(document.id)) {
                            withAnimation(.spring(duration: 0.35)) { record.toggle(document.id) }
                        }
                    }
                }
            }
        }
    }
}
