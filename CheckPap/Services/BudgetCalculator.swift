import Foundation

/// Budget repère d'un séjour, en fourchette :
/// - repère bas : indemnité mensuelle du Volontariat international (VIE), ramenée au jour ;
/// - repère haut : barème journalier des missions de l'État.
/// Chaque repère est donné en euros et dans la monnaie du pays.
enum BudgetCalculator {
    struct Amount: Equatable {
        let euros: Double
        let local: Double?
    }

    struct Estimate: Equatable {
        let low: Amount?
        let high: Amount
        let localCurrency: String?
    }

    /// Convertit un montant d'une devise à une autre avec des taux "unités pour 1 euro".
    static func convert(_ amount: Double, from: String, to: String, perEuro: [String: Double]) -> Double? {
        let fromRate = from == "EUR" ? 1 : perEuro[from]
        let toRate = to == "EUR" ? 1 : perEuro[to]
        guard let fromRate, let toRate, fromRate > 0 else { return nil }
        return amount / fromRate * toRate
    }

    static func estimate(
        perDiem: PerDiem, monthly: MonthlyAllowance?, days: Int, localCurrency: String?, rates: ExchangeRates
    ) -> Estimate? {
        let rate = rates.perEuro
        guard let high = amount(perDiem.amount * Double(days), currency: perDiem.currency, local: localCurrency, rates: rate)
        else { return nil }
        let low = monthly.flatMap {
            amount($0.amount / 30 * Double(days), currency: $0.currency, local: localCurrency, rates: rate)
        }
        let hasLocal = high.local != nil
        return Estimate(low: low, high: high, localCurrency: hasLocal ? localCurrency : nil)
    }

    private static func amount(_ value: Double, currency: String, local: String?, rates: [String: Double]) -> Amount? {
        guard let euros = convert(value, from: currency, to: "EUR", perEuro: rates) else { return nil }
        return Amount(euros: euros, local: local.flatMap { convert(value, from: currency, to: $0, perEuro: rates) })
    }
}

/// Durées proposées pour le budget.
enum StayDuration: Int, CaseIterable, Identifiable {
    case oneWeek = 7, twoWeeks = 14, oneMonth = 30, threeMonths = 90, sixMonths = 180, oneYear = 365

    var id: Int { rawValue }
}
