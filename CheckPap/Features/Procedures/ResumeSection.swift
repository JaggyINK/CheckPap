import SwiftData
import SwiftUI

/// "Reprendre mes dossiers" : les démarches commencées, en petites cartes horizontales.
struct ResumeSection: View {
    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router
    @Query(sort: \SavedProcedure.updatedAt, order: .reverse) private var saved: [SavedProcedure]

    var body: some View {
        let entries = saved.compactMap { store.entry(id: $0.procedureId) }
        if !entries.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Reprendre mes dossiers")
                    .font(.headline)
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(entries) { entry in
                            let progress = ProcedureProgress.compute(entryId: entry.id, store: store, saved: saved)
                            Button {
                                router.path.append(.checklist(entry.id))
                            } label: {
                                HStack(spacing: 10) {
                                    ProgressRing(progress: progress?.fraction ?? 0, lineWidth: 4)
                                        .frame(width: 28, height: 28)
                                    ContentText(entry.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(12)
                                .frame(width: 220, alignment: .leading)
                                .cardSurface(cornerRadius: 18)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                    .padding(.vertical, 2)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}
