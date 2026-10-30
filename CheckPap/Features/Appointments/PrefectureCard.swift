import SwiftUI

/// La préfecture de la personne, trouvée avec son code postal :
/// adresse, téléphone, site et prise de rendez-vous.
struct PrefectureCard: View {
    @Environment(ContentStore.self) private var store
    @Environment(\.locale) private var locale
    @AppStorage(UserLocation.departmentKey) private var departmentCode = ""
    @AppStorage(UserLocation.postalCodeKey) private var postalCode = ""
    @State private var input = ""
    @State private var notFound = false
    @State private var choosing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let department = store.prefectures?.department(code: departmentCode) {
                details(department)
            } else {
                postalCodeForm
            }
        }
        .sheet(isPresented: $choosing) {
            DepartmentPicker(selection: $departmentCode)
        }
    }

    private var postalCodeForm: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Indiquez votre code postal pour trouver votre préfecture et sa page de rendez-vous.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(spacing: 10) {
                TextField("Ex. : 94000", text: $input)
                    .keyboardType(.numberPad)
                    .textContentType(.postalCode)
                    .font(.title3.monospacedDigit())
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .cardSurface(cornerRadius: 14)
                Button("Valider", action: lookUp)
                    .primaryButton()
                    .disabled(input.filter(\.isNumber).count != 5)
            }
            if notFound {
                Text("Nous n'avons pas trouvé de préfecture pour ce code postal. Vérifiez-le, ou choisissez votre département dans la liste.")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
            Button("Choisir mon département dans la liste") { choosing = true }
                .font(.footnote.weight(.semibold))
        }
    }

    private func lookUp() {
        guard let code = PostalCode.departmentCode(input), store.prefectures?.department(code: code) != nil else {
            notFound = true
            return
        }
        notFound = false
        postalCode = input
        withAnimation(.snappy) { departmentCode = code }
    }

    @ViewBuilder
    private func details(_ department: Department) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: department.prefecture.resolved(locale))
                    .font(.headline)
                Text(verbatim: postalCode.isEmpty ? "\(department.code) · \(department.name)" : "\(postalCode) · \(department.name)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button("Changer") {
                input = ""
                withAnimation(.snappy) { departmentCode = "" }
            }
            .font(.caption.weight(.semibold))
        }
        if let appointment = department.appointmentUrl {
            primaryLink("Prendre rendez-vous sur le site de la préfecture", url: appointment)
        } else if let website = department.website {
            primaryLink("Ouvrir le site de la préfecture", url: website)
        } else if let directory = store.prefectures?.sources(for: department.sources).first?.url {
            // Site pas encore vérifié : la fiche de l'annuaire de l'administration donne site, horaires et contacts.
            primaryLink("Voir la fiche de la préfecture (site, horaires)", url: directory)
        }
        if let address = department.address {
            Label { Text(verbatim: address) } icon: { Image(systemName: "mappin") }
                .font(.subheadline)
        }
        if let phone = department.phone, let url = URL(string: "tel:\(phone)") {
            Link(destination: url) {
                Label(PhoneFormatter.format(phone), systemImage: "phone")
            }
            .font(.subheadline.weight(.semibold))
        }
        if let subprefectures = department.subprefecturesUrl {
            Link(destination: subprefectures) {
                Label("Votre commune dépend peut-être d'une sous-préfecture : voir la liste", systemImage: "building.2")
            }
            .font(.footnote.weight(.semibold))
        }
        SourcesList(sources: store.prefectures?.sources(for: department.sources) ?? [])
    }

    private func primaryLink(_ title: LocalizedStringKey, url: URL) -> some View {
        Link(destination: url) {
            Label(title, systemImage: "calendar.badge.plus")
                .frame(maxWidth: .infinity)
        }
        .primaryButton()
    }
}
