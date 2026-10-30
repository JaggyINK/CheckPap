import SwiftUI

/// Premier lancement : bienvenue et langue, puis code postal (facultatif).
struct OnboardingView: View {
    let onFinish: () -> Void

    @AppStorage(AppLanguage.storageKey) private var language = AppLanguage.system.rawValue
    @State private var page = 0

    var body: some View {
        ZStack {
            AppBackground()
            Group {
                if page == 0 {
                    LanguagePage(language: $language) { withAnimation(.spring(duration: 0.5)) { page = 1 } }
                        .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading).combined(with: .opacity)))
                } else {
                    PostalCodePage(onFinish: onFinish)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

private struct LanguagePage: View {
    @Binding var language: String
    let onNext: () -> Void

    var body: some View {
        ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            LogoMark(size: 88)
                .padding(.top, 40)
                .staggeredAppear(0)
            VStack(alignment: .leading, spacing: 8) {
                Text("Bienvenue sur Check Pap")
                    .font(.largeTitle.weight(.bold))
                Text("Vos démarches en France, une étape à la fois. Choisissez votre langue.")
                    .foregroundStyle(.secondary)
            }
            .staggeredAppear(1)

            VStack(spacing: 10) {
                ForEach(Array(AppLanguage.allCases.enumerated()), id: \.element.id) { index, option in
                    Button {
                        withAnimation(.snappy) { language = option.rawValue }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(verbatim: option.nativeName)
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.primary)
                                if let french = option.frenchName {
                                    Text(verbatim: french)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Image(systemName: language == option.rawValue ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(language == option.rawValue ? AnyShapeStyle(Brand.teal) : AnyShapeStyle(.tertiary))
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .padding(16)
                        .contentShape(.rect)
                        .cardSurface(cornerRadius: 18)
                    }
                    .buttonStyle(PressableButtonStyle())
                    .staggeredAppear(index + 2)
                }
            }
        }
        .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
        VStack(spacing: 10) {
            Button(action: onNext) {
                Text("Continuer")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .primaryButton()
            .controlSize(.large)
            IndependentServiceNotice()
        }
        .padding(.bottom, 8)
        }
    }
}

private struct PostalCodePage: View {
    let onFinish: () -> Void

    @State private var postalCode = ""
    @State private var invalid = false
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(Brand.teal)
                .frame(width: 88, height: 88)
                .cardSurface(cornerRadius: 28)
            VStack(alignment: .leading, spacing: 8) {
                Text("Où habitez-vous ?")
                    .font(.largeTitle.weight(.bold))
                Text("Votre code postal nous permet de vous indiquer votre préfecture et où prendre rendez-vous. Il reste sur votre téléphone.")
                    .foregroundStyle(.secondary)
            }
            TextField("Code postal, ex. : 94000", text: $postalCode)
                .keyboardType(.numberPad)
                .textContentType(.postalCode)
                .font(.title2.monospacedDigit())
                .focused($focused)
                .padding(16)
                .cardSurface(cornerRadius: 18)
            if invalid {
                Text("Ce code postal ne semble pas valide : il doit comporter 5 chiffres.")
                    .font(.footnote)
                    .foregroundStyle(.orange)
            }
            Spacer()
            Button {
                if UserLocation.save(postalCode: postalCode) {
                    onFinish()
                } else {
                    invalid = true
                }
            } label: {
                Text("Terminer")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .primaryButton()
            .controlSize(.large)
            .disabled(postalCode.filter(\.isNumber).count != 5)
            Button("Plus tard", action: onFinish)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 16)
        .onAppear { focused = true }
    }
}
