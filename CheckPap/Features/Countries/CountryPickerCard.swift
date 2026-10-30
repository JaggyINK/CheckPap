import SwiftUI

/// "Choisir un pays" : ouvre la liste de tous les pays et leurs fiches.
struct CountryPickerCard: View {
    @Environment(ContentStore.self) private var store
    @Environment(Router.self) private var router

    var body: some View {
        Button {
            router.path.append(.countries)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "globe.europe.africa.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(Brand.teal, in: .rect(cornerRadius: 16, style: .continuous))
                VStack(alignment: .leading, spacing: 3) {
                    Text("Choisir un pays")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("\(store.countries?.list.countries.count ?? 0) fiches pays : visas, santé, protection sociale, contacts")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                Image(systemName: "chevron.forward")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
            .cardSurface(cornerRadius: 22)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
