import SwiftUI

struct HeaderView: View {

    let text: String
    let fontSize: CGFloat?

    init(text: String, fontSize: CGFloat? = nil) {
        self.text = text
        self.fontSize = fontSize
    }

    var body: some View {
        HStack {
            Text(text)
                .style(.bold, size: fontSize != nil ? fontSize! : 20)
            Spacer()
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(text: "Autores")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
