import SwiftUI

struct PagesProgressView: View {

    let pagesRead: Int
    let totalPages: Int
    let lastUpdate: String

    @State var pageControl = 1

    var body: some View {
        VStack(spacing: 24) {
            SegmentedControlView(showMode: $pageControl)
            if pageControl == 1 {
                VStack(spacing: 8) {
                    Text("\(pagesRead)")
                        .padding(.top)
                    Text("de")
                    Text("\(totalPages) páginas")
                    Text("Última atualização \(lastUpdate)")
                }
                Spacer()
            } else {
                Text("Gráfico")
            }
        }
    }
}

struct PagesProgressView_Previews: PreviewProvider {
    static let read = 250
    static let total = 500
    static let update = "28/04/2022"
    static var previews: some View {
        PagesProgressView(pagesRead: read,
                          totalPages: total,
                          lastUpdate: update)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
