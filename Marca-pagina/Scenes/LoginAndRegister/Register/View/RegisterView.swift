import SwiftUI
import Combine

struct RegisterView: View {

    @ObservedObject var viewModel = RegisterViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        if viewModel.state == .loading {
            ProgressView()
        } else {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(Constants.imageName)
                    Text(Constants.imageSubtitle)
                        .style(.bold, size: 20)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 14)

                TextField(Constants.namePlaceholder, text: $viewModel.nameText)
                    .textInputAutocapitalization(.words)
                    .padding(.leading, 16)
                    .padding(.vertical, 6)
                    .background(getTextFieldBackground())
                    .cornerRadius(10)
                    .padding(.horizontal, 61)

                VStack(alignment: .leading, spacing: 0) {
                    TextField(Constants.emailPlacehlder, text: $viewModel.emailText)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding(.leading, 16)
                        .padding(.vertical, 6)
                        .background(getTextFieldBackground())
                        .cornerRadius(10)
                    if viewModel.emailIsInvalid {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                            Text(Constants.invalidEmail)
                                .style(.regular, size: 15)
                                .foregroundColor(.red)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 61)
                VStack(alignment: .leading, spacing: 0) {
                    HybridTextField(text: $viewModel.passwordText, placeHolder: Constants.passwordPlaceholder)
                }
                .padding(.horizontal, 61)
                VStack(alignment: .leading, spacing: 0) {
                    HybridTextField(text: $viewModel.confirmationPasswordText, placeHolder: Constants.confirmPassword)
                }
                .padding(.horizontal, 61)

                if viewModel.passwordInvalid {
                    VStack(spacing: 12) {
                        HStack(alignment: .center) {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                            Text("Crie uma senha forte:")
                                .style(.regular, size: 15)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 61)

                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(viewModel.passwordErros, id: \.self) { error in
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 6, height: 6)
                                        .foregroundColor(.red)
                                    Text(error)
                                        .style(.regular, size: 15)
                                        .foregroundColor(.red)
                                }

                            }
                        }
                        .padding(.leading, 12   )
                        Spacer()
                    }
                    .padding(.horizontal, 61)

                }

                Button {
                    viewModel.createUser()
                } label: {
                    HStack {
                        Spacer()
                        Text(Constants.registerText)
                            .style(.bold, size: 17)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .background(ColorAsset.pink.primary)
                    .cornerRadius(10)
                }
                .padding(.top, 16)
                .padding(.horizontal, 61)
                .disabled(!viewModel.enableButton)
            }
        }
    }

    enum Constants {
        static let imageName = "registerImage"
        static let imageSubtitle = "Ainda não tem uma conta?\nVamos criar agora!"
        static let namePlaceholder = "Nome completo"
        static let emailPlacehlder = "E-mail válido"
        static let passwordPlaceholder = "Senha"
        static let confirmPassword = "Repetir senha"
        static let registerText = "Cadastrar"
        static let registerWithApple = "Se cadastrar com Apple"
        static let appleLogoImage = "applelogo"
        static let invalidEmail = "Cadastre um email válido"

    }
    
    private func getButtonBackGroundColor() -> Color {
        colorScheme == .light ? .black : .white
    }

    private func getTextFieldBackground() -> Color {
        return Color(colorScheme == .light ? UIColor.systemGroupedBackground : UIColor.systemGray2)
    }

    private func getImageColor() -> Color {
        return colorScheme == .light ? .white : .black
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
