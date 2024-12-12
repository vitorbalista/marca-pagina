import SwiftUI

struct DescriptionComponents: View {

    let bookInfo: BookInfo
    let lineLimit: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 18) {
                Text("Descrição")
                    .style(.bold, size: 20)
                ExpandableText(bookInfo.getDescription(), lineLimit: lineLimit)
            }
            Spacer()
        }
    }
}

struct DescriptionComponents_Previews: PreviewProvider {

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
    static let lineLimit = 2

    static var previews: some View {
        DescriptionComponents(bookInfo: bookInfo, lineLimit: lineLimit)
    }
}
