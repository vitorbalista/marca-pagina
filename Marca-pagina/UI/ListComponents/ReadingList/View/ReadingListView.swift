import SwiftUI

struct ReadingListView: View {

    let status: Status
    let height: CGFloat
    let books: [SavedBook]
    let didSelectBook: (SavedBook) -> Void

    var body: some View {
        HorizontalListView(
            elements: books,
            cellSize: CGSize(width: 100, height: height),
            didSelectElement: didSelectBook
        )
    }
}

struct HeaderViewWithButton: View {

    var imageName: String?
    var foregroundColor: Color?
    let text: String
    let action: () -> Void

    var body: some View {
        HStack {
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(foregroundColor)
                    .frame(width: 16,
                           height: 21)
            }
            Text(text)
                .style(.bold, size: 20)
            Spacer()
            Text("Ver todos")
                .style(.regular, size: 16)
                .onNavigation {
                    action()
                }
                .foregroundColor(.accentColor)
        }
    }
}

 struct ReadingListView_Previews: PreviewProvider {
    static let height: CGFloat = 168
    static let bookDetails = BookDetails(title: "Sou hétero e sou top",
                                         authors: ["Manuelita", "Virto Balista"],
                                         publisher: "Blabla livros",
                                         publishedDate: "27/03/2000",
                                         description: "O livro mais aguardado na SmartFit",
                                         industryIdentifiers: nil,
                                         pageCount: 250,
                                         imageLinks: nil,
                                         language: "PT-BR",
                                         categories: ["Terror", "Suspense"])

    static let bookInfo = BookInfo(id: "123",
                                   volumeInfo: bookDetails)

    static let book: SavedBook = SavedBook(bookInfo: bookInfo,
                                           status: .want,
                                           coments: "coments",
                                           rating: 0.0,
                                           favorite: false,
                                           pagesRead: 0,
                                           startDate: Date(),
                                           lastUpdateDate: Date(),
                                           endDate: Date())

    static var previews: some View {
        ReadingListView(status: .want, height: height, books: [book]) { _ in }
            .previewLayout(.sizeThatFits)
            .padding()
    }
 }
