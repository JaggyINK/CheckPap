import SwiftUI

/// Budget repère selon la durée du séjour : une fourchette en euros et dans la monnaie du pays.
struct CountryBudgetCard: View {
    let country: Country
    let content: CountriesContent

    @State private var duration: StayDuration = .oneWeek

    var body: some View {
        if let budget = content.budget, let perDiem = content.perDiem(for: country.id) {
            let monthly = content.vieMonthly(for: country.id)
            let estimate = BudgetCalculator.estimate(
                perDiem: perDiem, monthly: monthly, days: duration.rawValue,
                localCurrency: content.localCurrency(for: country.id), rates: budget.rates
            )
            VStack(alignment: .leading, spacing: 14) {
                Label("Budget repère", systemImage: "eurosign.circle")
                    .font(.headline)

                FlowLayout(spacing: 8) {
                    ForEach(StayDuration.allCases) { option in
                        ChoiceChip(title: Self.title(for: option), isSelected: duration == option) {
                            withAnimation(.snappy) { duration = option }
                        }
                    }
                }

                if let estimate {
                    BudgetRange(estimate: estimate)
                        .animation(.snappy, value: duration)
                }

                BudgetExplanation(hasLow: monthly != nil, rateDate: budget.rates.date)

                SourcesList(sources: content.sources(for: [monthly?.source, perDiem.source, budget.rates.source].compactMap { $0 }))
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface(cornerRadius: 22)
        }
    }

    static func title(for duration: StayDuration) -> Text {
        switch duration {
        case .oneWeek: Text("1 semaine")
        case .twoWeeks: Text("2 semaines")
        case .oneMonth: Text("1 mois")
        case .threeMonths: Text("3 mois")
        case .sixMonths: Text("6 mois")
        case .oneYear: Text("1 an")
        }
    }
}

/// "≈ 700 € à 1 800 €", puis la même fourchette dans la monnaie du pays.
private struct BudgetRange: View {
    let estimate: BudgetCalculator.Estimate
    @Environment(\.locale) private var locale

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(verbatim: range(estimate.low?.euros, estimate.high.euros, code: "EUR"))
                .font(.system(.title, design: .rounded).weight(.bold))
                .contentTransition(.numericText(value: estimate.high.euros))
            if let code = estimate.localCurrency, let high = estimate.high.local {
                Text(verbatim: range(estimate.low?.local, high, code: code))
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Brand.teal)
                    .contentTransition(.numericText(value: high))
            }
        }
    }

    private func range(_ low: Double?, _ high: Double, code: String) -> String {
        let style = FloatingPointFormatStyle<Double>.Currency(code: code).precision(.fractionLength(0)).locale(locale)
        guard let low, low < high else { return "≈ " + high.formatted(style) }
        return "≈ \(low.formatted(style)) – \(high.formatted(style))"
    }
}

/// D'où viennent les deux repères, pour que la fourchette soit compréhensible.
private struct BudgetExplanation: View {
    let hasLow: Bool
    let rateDate: String
    @Environment(\.locale) private var locale

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if hasLow {
                Label("Repère bas : allocation mensuelle d'un volontaire international (VIE) dans ce pays, ramenée à la durée choisie. Elle correspond au coût de la vie d'un jeune installé sur place.",
                      systemImage: "arrow.down.circle")
            }
            Label("Repère haut : barème journalier que l'État verse à ses agents en mission dans ce pays (hôtel de type professionnel et repas).",
                  systemImage: "arrow.up.circle")
            Text("Ce sont des repères, pas des prix exacts : votre budget réel dépend de votre logement et de votre mode de vie.")
            if let date = DayDate.parse(rateDate) {
                Text("Taux de change du \(date.formatted(.dateTime.day().month(.wide).year().locale(locale)))")
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
}
