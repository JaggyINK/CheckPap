import SwiftUI

/// Réglages : langue, code postal, réglages iOS de l'app.
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @AppStorage(AppLanguage.storageKey) private var language = AppLanguage.system.rawValue
    @AppStorage(UserLocation.postalCodeKey) private var savedPostalCode = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var postalCode = ""
    @State private var invalid = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Langue", selection: $language) {
                        ForEach(AppLanguage.allCases) { option in
                            Text(verbatim: option.nativeName).tag(option.rawValue)
                        }
                    }
                } header: {
                    Text("Langue")
                } footer: {
                    Text("« Langue du téléphone » suit le réglage de votre iPhone.")
                }

                Section {
                    HStack {
                        TextField("Code postal", text: $postalCode)
                            .keyboardType(.numberPad)
                            .textContentType(.postalCode)
                        Button("Enregistrer") {
                            invalid = !UserLocation.save(postalCode: postalCode)
                        }
                        .disabled(postalCode.filter(\.isNumber).count != 5)
                    }
                    if invalid {
                        Text("Code postal non valide.")
                            .foregroundStyle(.orange)
                    }
                } header: {
                    Text("Votre code postal")
                } footer: {
                    Text("Sert à trouver votre préfecture. Il reste sur votre téléphone.")
                }

                Section {
                    Button("Ouvrir les réglages de l'iPhone pour Check Pap") {
                        if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
                    }
                    Button("Revoir l'écran d'accueil") {
                        hasCompletedOnboarding = false
                        dismiss()
                    }
                }

                Section {
                    IndependentServiceNotice()
                }
            }
            .navigationTitle("Réglages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") { dismiss() }
                }
            }
            .onAppear { postalCode = savedPostalCode }
        }
    }
}
