import SwiftUI

struct DropDownButtonView: View {

    @State var text = "Style"

    var body: some View {
        Menu {
            Button {
                self.text = "Batata"
            } label: {
                Text("Batata")
                Image(systemName: "arrow.down.right.circle")
            }
            Button {
                self.text = "Melancia"
            } label: {
                Text("Melancia")
                Image(systemName: "arrow.up.and.down.circle")
            }
        } label: {
             Text(text)
             Image(systemName: "tag.circle")
        }
        .background(Color.gray)
        .cornerRadius(16)
    }
}

struct DropDownButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DropDownButtonView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
