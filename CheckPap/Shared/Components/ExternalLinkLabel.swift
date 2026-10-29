import SwiftUI

/// Lien vers un site externe, avec l'icône "ouvrir".
struct ExternalLinkLabel: View {
    let link: StepLink

    var body: some View {
        Link(destination: link.url) {
            Label {
                ContentText(link.title)
                    .multilineTextAlignment(.leading)
            } icon: {
                Image(systemName: "arrow.up.right.square")
            }
            .font(.subheadline.weight(.semibold))
        }
        .tint(Brand.teal)
    }
}
