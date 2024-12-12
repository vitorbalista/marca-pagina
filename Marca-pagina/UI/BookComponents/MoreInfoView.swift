import Foundation
import SwiftUI

struct MoreInfoView: View {
    @State var selected = false

    let bookInfo: BookInfo

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                HeaderView(text: "Mais Informações")

                Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(selected ? 90 : 0))
                        .padding(.trailing)
            }
            .onTapGesture {
                selected.toggle()
            }

            if selected {
                HStack {
                    infos
                    Spacer()
                }
            }
        }
    }

    var infos: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ISBN-13: \(bookInfo.getISBN()?.first?.identifier ?? "Indisponível")")
                .style(.regular, size: 14)
                .foregroundColor(Color(uiColor: UIColor.separator))
            Text("Editora: \(bookInfo.getPublisher())")
                .style(.regular, size: 14)
                .foregroundColor(Color(uiColor: UIColor.separator))
            Text("Número de páginas: \(bookInfo.getNumberOfPages())")
                .style(.regular, size: 14)
                .foregroundColor(Color(uiColor: UIColor.separator))
            Text("Ano de publicação: \(bookInfo.getPublishedDate())")
                .style(.regular, size: 14)
                .foregroundColor(Color(uiColor: UIColor.separator))
        }
    }
}

struct MoreInfoView_Previews: PreviewProvider {
    static let height: CGFloat = 24
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

    static var previews: some View {
        MoreInfoView(bookInfo: bookInfo)
    }
}
