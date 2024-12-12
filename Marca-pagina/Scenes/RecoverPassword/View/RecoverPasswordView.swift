import SwiftUI

struct RecoverPasswordView: View {

    enum Constants {
        static let imageName = "RecoverPasswordImage"
        static let emailPlaceholder = "E-mail válido"
        static let recoverPasswordText = "Enviar e-mail"
        static let imageSubtitle = "Redefina sua senha"
        static let checkmarkImage = "checkmark"
        static let successRecovering = "E-mail de recuperação enviado com sucesso"
    }

    @ObservedObject var viewModel: RecoverPasswordViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if viewModel.viewState == .idle {
            if !viewModel.successRecoveringPassword {
                VStack(alignment: .center, spacing: 24) {
                    VStack(spacing: 8) {
                        Image(Constants.imageName)
                            .resizable()
                            .frame(height: 200)
                        Text(Constants.imageSubtitle)
                            .style(.bold, size: 20)
                    }
                    .padding(.horizontal, 90)
                    .padding(.top, 24)

                    VStack(spacing: 8) {
                        TextField(Constants.emailPlaceholder, text: $viewModel.emailText)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .frame(width: 268)
                            .padding(.leading, 16)
                            .padding(.vertical, 6)
                            .background(getTextFieldBackground())
                            .cornerRadius(10)
                        if let error = viewModel.error {
                            Text(error)
                                .style(.regular, size: 14)
                                .foregroundColor(ColorAsset.red.primary)
                        }
                    }

                    Button {
                        viewModel.recoverPassword()
                    } label: {
                        HStack {
                            Spacer()
                                Text(Constants.recoverPasswordText)
                                    .style(.bold, size: 17)
                                    .foregroundColor(Color.white)
                            Spacer()
                            }
                        .padding(.vertical, 14)
                        .background(ColorAsset.pink.primary)
                        .cornerRadius(10)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 122)

                    Spacer()

                }
            } else {
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        Image(systemName: Constants.checkmarkImage)
                            .resizable()
                            .foregroundColor(ColorAsset.pink.primary)
                            .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
                        Text(Constants.successRecovering)
                            .style(.bold, size: 20)
                            .foregroundColor(Color(UIColor.label))
                    }
                    Spacer()

                }
            }
        } else {
            ProgressView()
        }
    }

    private func getButtonBackGroundColor() -> Color {
        colorScheme == .light ? .black : .white
    }

    private func getTextFieldBackground() -> Color {
        return Color(colorScheme == .light ? UIColor.systemGroupedBackground : UIColor.systemGray2)
    }
}

struct RecoverPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordView(viewModel: RecoverPasswordViewModel())
    }
}
