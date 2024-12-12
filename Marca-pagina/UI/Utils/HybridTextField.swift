import SwiftUI

struct HybridTextField: View {

    @Binding var text: String
    @State var isSecure = true
    let placeHolder: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                if isSecure {
                    SecureField(placeHolder, text: $text)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)

                } else {
                    TextField(placeHolder, text: $text)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                }
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(getEyeSlashColor())
                    .padding(.trailing, 16)
                    .onTapGesture {
                        isSecure.toggle()
                    }
            }
            .padding(.leading, 16)
            .padding(.vertical, 6)
            .background(getTextFieldBackground())
            .cornerRadius(10)
        }
    }

    private func getTextFieldBackground() -> Color {
        return Color(colorScheme == .light ? UIColor.systemGroupedBackground : UIColor.systemGray2)
    }

    private func getEyeSlashColor() -> Color {
        colorScheme == .light ? .black : Color(UIColor.systemGray)
    }
}
