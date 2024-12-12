import SwiftUI

struct ReportButton: View {

    var body: some View {
        Button {

        } label: {
            ZStack {
                Capsule()
                    .strokeBorder()
                    .frame(width: 230, height: 33)

                HStack {
                    Image(systemName: "megaphone")
                        .padding(.trailing, 8)

                    Text("Precisa denunciar esse livro?")
                        .style(.regular, size: 13)
                }
            }
            .foregroundColor(ColorAsset.red.primary)
        }
    }
}

struct ReportButton_Previews: PreviewProvider {
    static var previews: some View {
        ReportButton()
    }
}
