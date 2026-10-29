import SwiftUI

/// Tuile d'une catégorie de démarches : icône, titre, sous-titre et nombre de démarches.
struct CategoryTile: View {
    let category: ProcedureCategory

    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router

    private var count: Int {
        store.availableEntries.filter { $0.category == category.id }.count
    }

    var body: some View {
        Button {
            router.path.append(.category(category.id))
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: category.symbol)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Brand.teal)
                    .frame(width: 48, height: 48)
                    .background(Brand.mint.opacity(0.18), in: .rect(cornerRadius: 14, style: .continuous))
                Spacer(minLength: 0)
                ContentText(category.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                ContentText(category.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text("^[\(count) démarche](inflect: true)")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Brand.teal)
            }
            .multilineTextAlignment(.leading)
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 170, alignment: .topLeading)
            .contentShape(.rect)
            .glassCard(cornerRadius: 24)
        }
        .buttonStyle(PressableButtonStyle())
        .accessibilityElement(children: .combine)
    }
}
