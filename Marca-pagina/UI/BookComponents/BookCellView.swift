import SwiftUI

// Pode ser usada para as conquistas também, basta utilizarmos nome da imagem como variável e o texto também

struct BookCellView: View {

    let book: BookInfo
    let size: CGSize

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.init(uiColor: UIColor.tertiarySystemBackground))
                .shadow(color: .black.opacity(0.2),
                        radius: 2, x: 1, y: 2)
                        .accessibilityLabel(book.volumeInfo.title)
                        .accessibilityAddTraits(.isButton)
            if let imageLink = book.getImageLink() {
                AsyncImage(url: imageLink) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(16)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image("book-placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(16)
            }
        }
        .frame(width: size.width,
               height: size.height)
    }
}

 struct BookCellView_Previews: PreviewProvider {

    static let text = "Olá"
    static let size = CGSize(width: 100,
                             height: 128)
    static let bookDetails = BookDetails(title: "Reri potter",
                                         authors: [],
                                         publisher: nil,
                                         publishedDate: nil,
                                         description: nil,
                                         industryIdentifiers: nil,
                                         pageCount: nil,
                                         imageLinks: nil,
                                         language: "pt-br",
                                         categories: nil)
    static let bookInfo = BookInfo(id: "12345", volumeInfo: bookDetails)

    static let savedBook = SavedBook(bookInfo: bookInfo,
                                               status: .want,
                                               coments: "coments",
                                               rating: 0.0,
                                               favorite: false,
                                               pagesRead: 0,
                                               startDate: Date(),
                                                lastUpdateDate: Date(),
                                               endDate: Date())
    static var previews: some View {
        BookCellView(book: bookInfo,
                     size: size)
            .previewLayout(.sizeThatFits)
            .padding()
    }
 }
