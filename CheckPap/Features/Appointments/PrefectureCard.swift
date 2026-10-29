import SwiftUI

/// La préfecture de la personne, trouvée avec son code postal :
/// adresse, téléphone, site et prise de rendez-vous.
struct PrefectureCard: View {
    @Environment(ContentStore.self) private var store
    @Environment(\.locale) private var locale
    @AppStorage("departmentCode") private var departmentCode = ""
    @AppStorage("postalCode") private var postalCode = ""
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
                    .glassCard(cornerRadius: 14)
                Button("Valider", action: lookUp)
                    .primaryGlassButton()
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
        if let destination = department.appointmentUrl ?? department.website {
            Link(destination: destination) {
                Label(department.appointmentUrl != nil ? "Prendre rendez-vous sur le site de la préfecture" : "Ouvrir le site de la préfecture",
                      systemImage: "calendar.badge.plus")
                    .frame(maxWidth: .infinity)
            }
            .primaryGlassButton()
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
}
