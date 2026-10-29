import Testing
@testable import CheckPap

struct BudgetCalculatorTests {
    let rates = ExchangeRates(date: "2026-10-01", source: "test", perEuro: ["BDT": 130, "USD": 1.1])

    @Test func convertsBetweenCurrenciesThroughTheEuro() throws {
        #expect(BudgetCalculator.convert(100, from: "EUR", to: "BDT", perEuro: rates.perEuro) == 13_000)
        let euros = try #require(BudgetCalculator.convert(110, from: "USD", to: "EUR", perEuro: rates.perEuro))
        #expect(abs(euros - 100) < 0.001)
        #expect(BudgetCalculator.convert(10, from: "XXX", to: "EUR", perEuro: rates.perEuro) == nil)
    }

    @Test func estimateGivesARangeFromBothBenchmarks() throws {
        let perDiem = PerDiem(country: "BD", amount: 200, currency: "EUR", source: "test")
        let monthly = MonthlyAllowance(country: "BD", amount: 3000, currency: "EUR", source: "test")
        let estimate = try #require(BudgetCalculator.estimate(
            perDiem: perDiem, monthly: monthly, days: 7, localCurrency: "BDT", rates: rates
        ))
        #expect(estimate.high == .init(euros: 1400, local: 182_000))
        #expect(estimate.low == .init(euros: 700, local: 91_000))
        #expect(estimate.localCurrency == "BDT")
    }

    @Test func withoutLowBenchmarkOnlyTheHighOneIsGiven() throws {
        let perDiem = PerDiem(country: "ZZ", amount: 50, currency: "EUR", source: "test")
        let estimate = try #require(BudgetCalculator.estimate(
            perDiem: perDiem, monthly: nil, days: 2, localCurrency: "QQQ", rates: rates
        ))
        #expect(estimate.low == nil)
        #expect(estimate.high == .init(euros: 100, local: nil))
        #expect(estimate.localCurrency == nil)
    }
}
