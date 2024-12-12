import SwiftUI

struct ReadingComponentView: View {

    let book: SavedBook
    let frameSize: CGSize
    let totalPages: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.init(uiColor: UIColor.tertiarySystemBackground))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 0)

            HStack(alignment: .top) {
                if let imageLink = book.bookInfo.getImageLink() {
                    AsyncImage(url: imageLink) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(16)
                            .padding(.top, 10)
                            .padding(.bottom, 9)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image("book-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(16)
                        .padding(.top, 10)
                        .padding(.bottom, 9)
                }
                VStack(alignment: .leading) {
                    Text(book.bookInfo.getBookTitle())
                        .style(.bold, size: 17)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
//                    if let authors = book.bookInfo.getAuthors() {
//                        Text(authors.first ?? "Autor não encontrado")
//                            .font(.callout)
//                            .foregroundColor(.secondary)
//                            .padding(.top, 2)
//                    }

                    Spacer()
                        .layoutPriority(0)

                    ProgressBar(book: book)
                    Text("Atualização \(Date.getDateInDDMMYYYY(book.lastUpdateDate))")
                        .style(.regular, size: 9)
                }
                .padding(.vertical, 10)
                .padding(.leading, 8)
                .frame(alignment: .top)
                .layoutPriority(2)
            }
            .padding(.horizontal, 16)
        }
        .frame(
            width: frameSize.width,
            height: frameSize.height + 10
        )
        .accessibilityElement(children: .combine)
    }
}

struct ReadingComponentView_Previews: PreviewProvider {
    static let size = CGSize(width: UIScreen.main.bounds.width - 32,
                             height: UIScreen.main.bounds.height/5)
    static let imageSize = CGSize(width: 82, height: 105)

    // swiftlint:disable line_length
    static let imageLinks = ImageLinks(
        smallThumbnail: "http://books.google.com/books/content?id=b7-59OQ9PtQC&printsec=frontcover&img=1&zoom=5&edge=curl&imgtk=AFLRE70Zpd9AhQCAmpl93j9G94evFRXZSo82tmost8uhMvKKyZgyGnBYSJTaBLsAsYkOFvXkXyCUOgfwl61tSs7Q9tLM1jWwCm0afi_i0xL3Lf1WkPNxJQ_9Mqs88dYG-j8VD-oXYtUP&source=gbs_api",
        thumbnail: "http://books.google.com/books/content?id=b7-59OQ9PtQC&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE71baPJaKCDKYJqio2fvtFw10rBwVrJvgEYsmJh73fHElQxeSP92I3IsuphoCileeIgQjzwDD2OqkVnzyDSS5lm6570nsp-SZ2JXkNXWWpEJUnx0yDm6btgAy4J7SyKL-EMiFJUl&source=gbs_api")
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

    static let bookInfo = BookInfo(id: "123",
                                   volumeInfo: bookDetails)

    static let book = SavedBook(bookInfo: bookInfo,
                                status: .inProgress,
                                coments: "comments",
                                rating: 5.0,
                                favorite: false,
                                pagesRead: 0,
                                startDate: Date(),
                                lastUpdateDate: Date(),
                                endDate: Date())

    static var previews: some View {
        ReadingComponentView(book: book, frameSize: size,
                             totalPages: 500
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
