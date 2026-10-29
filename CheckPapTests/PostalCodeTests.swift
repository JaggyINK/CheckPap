import Testing
@testable import CheckPap

struct PostalCodeTests {
    @Test(arguments: [
        ("94000", "94"), ("75011", "75"), ("01000", "01"),
        ("20000", "2A"), ("20200", "2B"), ("97400", "974"), ("97600", "976"),
    ])
    func findsTheDepartment(postalCode: String, department: String) {
        #expect(PostalCode.departmentCode(postalCode) == department)
    }

    @Test func rejectsIncompleteCodes() {
        #expect(PostalCode.departmentCode("9400") == nil)
        #expect(PostalCode.departmentCode("abcde") == nil)
    }
}
