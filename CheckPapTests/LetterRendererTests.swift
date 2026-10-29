import Testing
@testable import CheckPap

struct LetterRendererTests {
    @Test func fillsKnownFields() {
        let text = LetterRenderer.render("Je soussigné(e) {{full_name}}, le {{today}}.",
                                         values: ["full_name": "Amina DIALLO", "today": "29 octobre 2026"])
        #expect(text == "Je soussigné(e) Amina DIALLO, le 29 octobre 2026.")
    }

    @Test func emptyOrMissingFieldsStayVisible() {
        let text = LetterRenderer.render("{{full_name}} / {{foreigner_number}}", values: ["full_name": "  "])
        #expect(text == "\(LetterRenderer.placeholder) / \(LetterRenderer.placeholder)")
    }

    @Test func phoneNumbersAreGroupedByPairs() {
        #expect(PhoneFormatter.format("0806001620") == "08 06 00 16 20")
        #expect(PhoneFormatter.format("3939") == "3939")
    }
}
