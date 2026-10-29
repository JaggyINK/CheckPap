import SwiftData
import SwiftUI

/// Accueil : logo, accroche et liste des démarches (tirée de `catalog.json`).
struct HomeView: View {
    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router
    @Query private var saved: [SavedProcedure]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Wordmark()
                    .padding(.top, 8)
                    .staggeredAppear(0)
                hero
                    .staggeredAppear(1)
                procedures
                IndependentServiceNotice()
                    .padding(14)
                    .glassCard(cornerRadius: 18)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
        .toolbar(.hidden, for: .navigationBar)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Vos démarches, une étape à la fois.")
                .font(.largeTitle.weight(.bold))
                .fontDesign(.rounded)
            Text("Choisissez votre situation, répondez à quelques questions et retrouvez les pièces demandées par la préfecture.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var procedures: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quelle est votre démarche ?")
                .font(.headline)
                .staggeredAppear(2)

            switch store.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            case let .failed(message):
                Label(message, systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.secondary)
            case .loaded:
                ForEach(Array(store.availableEntries.enumerated()), id: \.element.id) { index, entry in
                    Button {
                        open(entry)
                    } label: {
                        ProcedureCard(entry: entry, progress: progress(for: entry))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .staggeredAppear(index + 3)
                }
            }
        }
    }

    /// Une démarche déjà commencée s'ouvre directement sur la liste.
    private func open(_ entry: CatalogEntry) {
        if saved.contains(where: { $0.procedureId == entry.id }) {
            router.path.append(.checklist(entry.id))
        } else {
            router.path.append(.intro(entry.id))
        }
    }

    private func progress(for entry: CatalogEntry) -> (done: Int, total: Int)? {
        guard let record = saved.first(where: { $0.procedureId == entry.id }),
              let procedure = store.procedures[entry.id]
        else { return nil }
        let documents = RulesEngine.documents(in: procedure, answers: record.answers)
        let done = documents.filter { record.isChecked($0.id) }.count
        return (done, documents.count)
    }
}

private struct ProcedureCard: View {
    let entry: CatalogEntry
    let progress: (done: Int, total: Int)?

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: entry.symbol)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Brand.teal)
                .frame(width: 46, height: 46)
                .background(Brand.mint.opacity(0.18), in: .circle)

            VStack(alignment: .leading, spacing: 3) {
                ContentText(entry.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                if let progress {
                    Text("\(progress.done) sur \(progress.total) pièces prêtes")
                        .font(.subheadline)
                        .foregroundStyle(Brand.teal)
                } else {
                    ContentText(entry.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .multilineTextAlignment(.leading)

            Spacer(minLength: 0)

            if let progress {
                ProgressRing(progress: Double(progress.done) / Double(max(progress.total, 1)), lineWidth: 4)
                    .frame(width: 26, height: 26)
            } else {
                Image(systemName: "chevron.forward")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
        .glassCard(cornerRadius: 22)
        .accessibilityElement(children: .combine)
    }
}
