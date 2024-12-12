import SwiftUI

struct HorizontalListView: View {

    let elements: [SavedBook]
    let cellSize: CGSize

    let didSelectElement: (SavedBook) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(elements) { book in
                    BookCellView(book: book.bookInfo,
                                     size: cellSize)
                        .onTapGesture {

                            didSelectElement(book)
                        }
                        .padding(.vertical, 3)
                }
            }
        }
    }

    func getImageFromData(data: Data?) -> Image {
        if let safeData = data {
            if let uiImage = UIImage(data: safeData) {
                let image = Image(uiImage: uiImage)
                return image
            }
        }
        return Image("book-placeholder")
    }
}

extension SavedBook: Identifiable {}

 struct HorizontalListView_Previews: PreviewProvider {

    static let cellSize = CGSize(width: 100, height: 128)

    static let volumeInfo = BookDetails(title: "title",
                                        authors: [],
                                        publisher: nil,
                                        publishedDate: nil,
                                        description: nil,
                                        industryIdentifiers: nil,
                                        pageCount: nil,
                                        imageLinks: nil,
                                        language: "pt-br",
                                        categories: nil)

    static let bookModel = BookInfo(id: "uii", volumeInfo: volumeInfo)

    static let books: [SavedBook] = [SavedBook(bookInfo: bookModel,
                                               status: .want,
                                               coments: "coments",
                                               rating: 0.0,
                                               favorite: false,
                                               pagesRead: 0,
                                               startDate: Date(),
                                               lastUpdateDate: Date(),
                                               endDate: Date())]

    static var previews: some View {
        HorizontalListView(elements: books, cellSize: cellSize) { _ in }
            .previewLayout(.sizeThatFits)
            .padding()
    }
 }
