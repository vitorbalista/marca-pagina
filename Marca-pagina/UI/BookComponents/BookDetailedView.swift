import SwiftUI

struct BookDetailedView: View {

    let bookInfo: BookInfo
    let score: Int
    let imageHeight: CGFloat
    let imageWidth: CGFloat

    var body: some View {
        VStack {
            if let subtitle = bookInfo.getBookSubtitle() {
                Text(subtitle)
                    .style(.regular, size: 17)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 15)
                    .padding(.top, 6)
            }

            VStack {
                if let imageLink = bookInfo.getImageLink() {
                    AsyncImage(url: imageLink) { image in
                        image
                            .resizable()
                            .frame(width: imageWidth, height: imageHeight)
                            .background(.blue)
                            .cornerRadius(16)
                    } placeholder: {
                        ProgressView()
                            .frame(width: imageWidth, height: imageHeight)
                    }
                }

                if let author = bookInfo.getAuthors().first {
                    Text(author)
                        .style(.regular, size: 17)
                        .foregroundColor(.secondary)
                        .padding(.top, 16)
                }
            }
        }
    }
}

// Componente da pontuacao que preenche as estrelas dependendo da nota nos favoritos

struct StarsGrade: View {

    let score: Int

    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor( index + 1 <= score ? Color.init("pink") :
                                        Color.init(uiColor: UIColor.opaqueSeparator))
            }
        }
    }
}

struct BookDetailedView_Previews: PreviewProvider {

    static let score = 3
    static let imageHeight: CGFloat = 378
    static let imageWidth: CGFloat = 250
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
        BookDetailedView(bookInfo: bookInfo,
                         score: score,
                         imageHeight: imageHeight,
                         imageWidth: imageWidth)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
