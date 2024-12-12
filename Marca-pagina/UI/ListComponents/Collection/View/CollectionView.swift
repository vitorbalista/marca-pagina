import SwiftUI

struct CollectionView: View {

    // 1. Itens por linha e espacamento entre eles
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    let horizontalSpacing: CGFloat

    private var books: [SavedBook] = []
    var didSelectBook: (SavedBook) -> Void

    init(horizontalSpacing: CGFloat = 16,
         books: [SavedBook] = [],
         didSelectBook: @escaping (SavedBook) -> Void) {
        self.horizontalSpacing = horizontalSpacing
        self.books = books
        self.didSelectBook = didSelectBook
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(books) { element in
                    BookCellView(book: element.bookInfo,
                                 size: CGSize(width: getWidth(),
                                              height: UIScreen.main.bounds.height/5))
                    .onTapGesture {
                        didSelectBook(element)
                    }
                }
            }
            .padding()
        }
    }

    func getWidth() -> CGFloat {

        // Calculo o tamanho utilizando o width disponivel e
        // removo o espaço que sera o numero de itens
        // +1 devido a um dos lados(3 espacos referente a leading e entre os card)
        // e um extra devido o espaco do trailing
        let width: CGFloat = (UIScreen.main.bounds.width - horizontalSpacing * (4)) / 3
        return width
    }
}

struct CollectionView_Previews: PreviewProvider {
    static let itemPerRow: CGFloat = 3
    static let horizontalSpacing: CGFloat = 16
    static let height: CGFloat = 128

    // swiftlint:disable line_length
    static let thumbnail = "https://d3ugyf2ht6aenh.cloudfront.net/stores/746/397/products/maca-argentina1-a86acef532d11addf315221676880019-1024-1024.jpg"
    static let smallThumbnail = "https://d3ugyf2ht6aenh.cloudfront.net/stores/746/397/products/maca-argentina1-a86acef532d11addf315221676880019-1024-1024.jpg"

    static let imageLinks: ImageLinks = ImageLinks(smallThumbnail: smallThumbnail,
                                                   thumbnail: thumbnail)

    static let bookDetails = BookDetails(title: "Sou hétero e sou top",
                                         authors: ["Manuelita", "Virto Balista"],
                                         publisher: "Blabla livros",
                                         publishedDate: "27/03/2000",
                                         description: "O livro mais aguardado na SmartFit",
                                         industryIdentifiers: nil,
                                         pageCount: 250,
                                         imageLinks: imageLinks,
                                         language: "PT-BR",
                                         categories: ["Terror", "Suspense"])

    static let bookInfo1 = BookInfo(id: "123",
                                   volumeInfo: bookDetails)
    static let bookInfo2 = BookInfo(id: "124",
                                   volumeInfo: bookDetails)

    static let books: [SavedBook] = [
        SavedBook(bookInfo: bookInfo1,
                  status: .want,
                  coments: "coments",
                  rating: 0.0,
                  favorite: false,
                  pagesRead: 0,
                  startDate: Date(),
                  lastUpdateDate: Date(),
                  endDate: Date()),
        SavedBook(bookInfo: bookInfo2,
                  status: .want,
                  coments: "coments",
                  rating: 0.0,
                  favorite: false,
                  pagesRead: 0,
                  startDate: Date(),
                  lastUpdateDate: Date(),
                  endDate: Date())
    ]

    static var previews: some View {
        CollectionView(books: books) { _ in }
    }
}

struct BooksStack: View {
    let books: [SavedBook]
    let width: CGFloat
    let height: CGFloat
    let horizontalSpacing: CGFloat
    var body: some View {
        HStack(spacing: horizontalSpacing) {
            ForEach(books, id: \.bookInfo.id) { book in
                BookCellView(book: book.bookInfo,
                             size: CGSize(width: width,
                                          height: height))
            }
        }
        .padding()
    }

    func getImageFromData(data: Data?) -> Image {
        if let safeData = data {
            if let uiImage = UIImage(data: safeData) {
                let image = Image(uiImage: uiImage)
                return image
            }
        }
        return Image(systemName: "cloud")
    }
}
