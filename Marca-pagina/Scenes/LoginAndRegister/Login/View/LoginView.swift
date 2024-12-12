import Foundation
import SwiftUI

struct LoginView: View {

    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: LoginViewModel

    enum Constants {
        static let imageName = "registerImage"
        static let imageSubtitle = "Ops... Você ainda não fez o login, \n vamos fazer?"
        static let emailPlaceholder = "E-mail cadastrado"
        static let passwordPlaceholder = "Senha cadastrada"
        static let loginApple = "Sign in with Apple"
        static let appleLogoImage = "applelogo"
        static let loginText = "Login"
    }

    var body: some View {
        if viewModel.state == .idle {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(Constants.imageName)
                    Text(Constants.imageSubtitle)
                        .style(.bold, size: 20)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 14)

                if viewModel.error {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                        Text("E-mail ou senha incorretos")
                            .style(.regular, size: 15)
                            .foregroundColor(.red)
                    }
                    .padding(.top, 8)
                }

                VStack(alignment: .leading, spacing: 0) {
                    TextField(Constants.emailPlaceholder, text: $viewModel.emailText)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding(.leading, 16)
                        .padding(.vertical, 6)
                        .background(getTextFieldBackground())
                        .cornerRadius(10)
                }
                .padding(.horizontal, 61)
                VStack(alignment: .leading, spacing: 0) {
                    HybridTextField(
                        text: $viewModel.passwordText,
                        placeHolder: Constants.passwordPlaceholder
                    )
                }
                .padding(.horizontal, 61)

                Button {
                    viewModel.goToRecover()
                } label: {
                    HStack {
                        Spacer()
                        Text("Esqueceu sua senha?")
                            .style(.bold, size: 13)
                            .foregroundColor(ColorAsset.pink.primary)
                    }
                }
                .padding(.horizontal, 61)

                Button {
                    viewModel.signInWithEmail()
                } label: {
                    HStack {
                        Spacer()
                            Text(Constants.loginText)
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

                Text("OU")
                    .style(.regular, size: 13)
                    .foregroundColor(Color(UIColor.systemGray))

                Button {
                    viewModel.handleSignInWithApple()
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: Constants.appleLogoImage)
                            .foregroundColor(getImageColor())
                            .padding(.bottom, 4)
                        Text(Constants.loginApple)
                            .style(.bold, size: 17)
                            .foregroundColor(getImageColor())
                    }
                    .padding(.leading, 40)
                    .padding(.trailing, 52)
                    .padding(.vertical, 14)
                    .background(getButtonBackGroundColor())
                    .cornerRadius(10)
                }

                HStack(spacing: 4) {
                    Text("Novo no Marca Página?")
                        .style(.regular, size: 13)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    Button {
                        viewModel.goToRegister()
                    } label: {
                        Text("Registrar")
                            .style(.bold, size: 13)
                            .foregroundColor(ColorAsset.pink.primary)
                    }
                }
                .padding(.horizontal, 61)
            }
            .ignoresSafeArea(.keyboard)
        } else {
            ProgressView("Waiting for login")
        }

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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: .init(coordinator: .init()))
    }
}
