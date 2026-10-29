import SwiftUI

/// Choisir son département (numéro ou nom), pour afficher sa préfecture.
struct DepartmentPicker: View {
    @Binding var selection: String
    @Environment(ContentStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    private var departments: [Department] {
        let all = store.prefectures?.departments ?? []
        let needle = ProcedureSearch.normalize(query)
        guard !needle.isEmpty else { return all }
        return all.filter { $0.code.hasPrefix(needle) || ProcedureSearch.normalize($0.name).contains(needle) }
    }

    var body: some View {
        NavigationStack {
            List(departments) { department in
                Button {
                    selection = department.code
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        Text(verbatim: department.code)
                            .font(.subheadline.weight(.bold).monospacedDigit())
                            .foregroundStyle(Brand.teal)
                            .frame(width: 40, alignment: .leading)
                        Text(verbatim: department.name)
                            .foregroundStyle(.primary)
                        Spacer()
                        if department.code == selection {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Brand.teal)
                        }
                    }
                }
            }
            .searchable(text: $query, prompt: Text("Numéro ou nom du département"))
            .navigationTitle("Votre département")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }
}
