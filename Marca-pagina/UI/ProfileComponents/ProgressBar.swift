import SwiftUI
import UIKit

struct ProgressBar: View {

    let book: SavedBook

    private var progress: Double {
        if let pagesRead = book.pagesRead {
           return  Double(pagesRead) / Double(book.bookInfo.getNumberOfPages())
        } else {
            return 0
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(height: 4)
                        .foregroundColor(Color(UIColor.systemGray2))

                    RoundedRectangle(cornerRadius: 3)
                        .foregroundColor(ColorAsset.pink.primary)
                        .frame(
                            width: progress * geometry.size.width,
                            height: 4
                        )
                }
                HStack {
                    Text("\(Int(progress * 100))%")
                        .style(.regular, size: 11)
                    Spacer()
                    Text("\(book.pagesRead ?? 0)/\(book.bookInfo.getNumberOfPages()) páginas")
                        .style(.regular, size: 11)
                }
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static let size = CGSize(width: UIScreen.main.bounds.width - 32,
                             height: UIScreen.main.bounds.height/5)
    static let imageSize = CGSize(width: 82, height: 105)

    // swiftlint:disable line_length
    static let imageLinks = ImageLinks(
        smallThumbnail: "http://books.google.com/books/content?id=mssBsa0Vf1UC&printsec=frontcover&img=1&zoom=5&edge=curl&imgtk=AFLRE72Q5G5pySXWZmCntyubpiQjqKR7WSJS89QvnTLdB0QPrRC4QXByqfsV7sszjmmwxXs1dmgFf3eQzcEOsOpjhcozU5RPFzUhox6ewCrARsMaGjxWQz52MzVvA3r80PlhP9i4rMwr&source=gbs_api",
        thumbnail: "http://books.google.com/books/content?id=mssBsa0Vf1UC&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE710_sR75y5kTreOL-VxEQ37o67yUAm8m22AnF-in3n1HCMx8wfUO6LscVQUgzFv65TrM-t_9xk-0yDsa9OMzVRhwhekwuejBPNPRkXxGC71t-w1AiOYQLkOOErbcE-ROpNCcvRK&source=gbs_api")
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
                                pagesRead: 100,
                                startDate: Date(),
                                lastUpdateDate: Date(),
                                endDate: Date())

    static var previews: some View {
        ProgressBar(book: book)
            .padding()
    }
}
