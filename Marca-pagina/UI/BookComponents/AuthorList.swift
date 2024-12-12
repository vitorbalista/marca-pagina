import SwiftUI

struct AuthorList: View {

    let cellSize: CGSize
    let listHeight: CGFloat
    let authors: [String]?

    var body: some View {
        VStack {
            HeaderView(text: "Autores")
            HorizontalListViewAuthor(authors: authors,
                                     cellSize: cellSize,
                                     listHeight: listHeight)
        }
    }
}

struct HorizontalListViewAuthor: View {

    let authors: [String]?
    var cellSize: CGSize
    var listHeight: CGFloat

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if let authors = authors {
                LazyHStack {
                    ForEach(authors, id: \.self) { author in
                        HStack {
                            ProfileCell(imageName: "user padrao",
                                        name: author,
                                        frameSize: cellSize,
                                        imageSize: CGSize(width: cellSize.width * 0.40,
                                                          height: cellSize.height * 0.40),
                                        profilePosition: .horizontal)
                                .padding(.trailing, 10)
                            Divider()
                                .opacity(authors.lastIndex(of: author) == (authors.count - 1) ? 0 : 1)
                                .frame(height: 24)
                        }
                    }
                }
            }
        }.frame(height: listHeight)
    }
}

struct AuthorList_Previews: PreviewProvider {

    static let size = CGSize(width: 184, height: 64)
    static let list: CGFloat = 96

    static var previews: some View {
        AuthorList(cellSize: size,
                   listHeight: list,
                   authors: ["Clarice Lispector", "Machado de assis", "William Shakeaspere", "Fernando Escritor"])
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
