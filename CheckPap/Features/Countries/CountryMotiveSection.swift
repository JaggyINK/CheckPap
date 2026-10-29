import SwiftUI

/// "Votre projet" : choix du motif et de l'âge, puis ce que le pays demande.
struct CountryMotiveSection: View {
    let country: Country
    let content: CountriesContent

    @State private var selected: String?
    @AppStorage("expatriationAge") private var age = 25

    private var motives: [CountryMotive] {
        content.motives(for: country.id).sorted {
            (CountryMotiveKind.order.firstIndex(of: $0.id) ?? 99) < (CountryMotiveKind.order.firstIndex(of: $1.id) ?? 99)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Votre projet")
                .font(.headline)

            if !motives.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(motives) { motive in
                        ChoiceChip(title: Text(CountryMotiveKind.title(motive.id)), isSelected: selected == motive.id) {
                            withAnimation(.snappy) { selected = selected == motive.id ? nil : motive.id }
                        }
                    }
                }
            }

            Stepper(value: $age, in: 16 ... 99) {
                Text("Votre âge : \(age) ans")
                    .font(.subheadline.weight(.semibold))
            }

            if let holiday = content.workingHoliday(for: country.id) {
                WorkingHolidayNotice(holiday: holiday, age: age, content: content)
            }

            if let motive = motives.first(where: { $0.id == selected }) {
                MotiveDetails(motive: motive, content: content)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else if motives.isEmpty {
                Text("Les conditions détaillées par motif ne sont pas encore disponibles pour ce pays. Consultez les liens utiles ci-dessous.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 22)
    }
}

/// Programme vacances-travail : on compare l'âge saisi aux limites publiées, sans rien promettre.
private struct WorkingHolidayNotice: View {
    let holiday: WorkingHoliday
    let age: Int
    let content: CountriesContent

    private var inRange: Bool { (holiday.minAge ... holiday.maxAge).contains(age) }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label {
                if inRange {
                    Text("Un programme vacances-travail existe avec ce pays (\(holiday.minAge) à \(holiday.maxAge) ans) : votre âge est dans la tranche.")
                } else {
                    Text("Un programme vacances-travail existe avec ce pays, réservé aux \(holiday.minAge) à \(holiday.maxAge) ans.")
                }
            } icon: {
                Image(systemName: inRange ? "checkmark.circle" : "info.circle")
            }
            .font(.footnote)
            .foregroundStyle(inRange ? AnyShapeStyle(Brand.teal) : AnyShapeStyle(.secondary))
            SourcesList(sources: content.sources(for: [holiday.source]))
        }
    }
}

private struct MotiveDetails: View {
    let motive: CountryMotive
    let content: CountriesContent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(CountryMotiveKind.title(motive.id), systemImage: CountryMotiveKind.symbol(motive.id))
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Brand.teal)
            if let age = motive.age {
                Callout(.info, age)
            }
            ForEach(Array((motive.conditions ?? []).enumerated()), id: \.offset) { _, condition in
                Label { ContentText(condition) } icon: { Image(systemName: "checkmark.circle") }
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let costs = motive.costs, !costs.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Coûts")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    ForEach(Array(costs.enumerated()), id: \.offset) { _, cost in
                        Label { ContentText(cost) } icon: { Image(systemName: "creditcard") }
                            .font(.subheadline)
                    }
                }
            }
            ForEach(motive.forms ?? [], id: \.url) { ExternalLinkLabel(link: $0) }
            SourcesList(sources: content.sources(for: motive.sources))
        }
    }
}
