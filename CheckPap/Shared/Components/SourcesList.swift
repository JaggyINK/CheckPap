import SwiftUI

/// Liens vers les sources d'un élément (chaque information affichée a sa source).
struct SourcesList: View {
    let sources: [Source]

    var body: some View {
        if !sources.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Text("Source")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                ForEach(sources) { source in
                    Link(destination: source.url) {
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Image(systemName: "arrow.up.right.square")
                            Text(verbatim: "\(source.publisher) · \(source.title)")
                                .multilineTextAlignment(.leading)
                        }
                        .font(.caption)
                    }
                    .tint(Brand.teal)
                }
            }
        }
    }
}
