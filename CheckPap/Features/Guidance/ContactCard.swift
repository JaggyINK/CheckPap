import SwiftUI

/// Un service qui peut aider : ce qu'il fait, son téléphone, son site.
struct ContactCard: View {
    let contact: Contact

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: contact.symbol ?? "person.crop.circle")
                .font(.body.weight(.semibold))
                .foregroundStyle(Brand.teal)
                .frame(width: 40, height: 40)
                .background(Brand.mint.opacity(0.18), in: .circle)

            VStack(alignment: .leading, spacing: 6) {
                ContentText(contact.title)
                    .font(.body.weight(.semibold))
                ContentText(contact.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 16) {
                    if let phone = contact.phone, let url = URL(string: "tel:\(phone)") {
                        Link(destination: url) {
                            Label(PhoneFormatter.format(phone), systemImage: "phone")
                        }
                    }
                    if let link = contact.link {
                        ExternalLinkLabel(link: link)
                    }
                }
                .font(.subheadline.weight(.semibold))
                .tint(Brand.teal)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 18)
    }
}

/// "0806001620" devient "08 06 00 16 20".
enum PhoneFormatter {
    static func format(_ number: String) -> String {
        let digits = number.filter(\.isNumber)
        guard digits.count == 10 else { return number }
        return stride(from: 0, to: 10, by: 2)
            .map { offset in
                let start = digits.index(digits.startIndex, offsetBy: offset)
                return String(digits[start ..< digits.index(start, offsetBy: 2)])
            }
            .joined(separator: " ")
    }
}
