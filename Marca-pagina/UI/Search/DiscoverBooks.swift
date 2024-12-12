import SwiftUI

struct DiscoverBooks: View {

    enum Constants {
        static let cardHeight: CGFloat = 157
    }

    @ObservedObject var viewModel: DiscoverBooksViewModel
    @Environment(\.colorScheme) var colorScheme

    init(viewModel: DiscoverBooksViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.selectedList.title)
                    .style(.bold, size: 28)
                    .padding([.leading, .trailing], 32)
                    .padding(.top, 24)
                GeometryReader { geometry in
                    ZStack {
                        if let url = URL(string: viewModel.imageURL(colorScheme: colorScheme)) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: geometry.size.height)
                                    .clipped()
                            } placeholder: {
                                EmptyView()
                                    .frame(height: geometry.size.height)
                            }
                        }
                        VStack(alignment: .center, spacing: 16) {
                            HStack {
                                Text(viewModel.selectedList.description)
                                    .style(.regular, size: 17)
                                    .multilineTextAlignment(.leading)
                                    .padding([.leading, .trailing], 32)
                                Spacer()
                            }
                            if viewModel.viewState == .loading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            } else {
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack(spacing: 16) {
                                        ForEach(viewModel.books) { book in
                                            BookTransparentView(
                                                bookInfoViewModel: viewModel.getBookInfoViewModel(book: book)
                                            )
                                            .frame(width: UIScreen.main.bounds.width - 2*32,
                                                   height: Constants.cardHeight)
                                            .padding(.horizontal, 8)
                                            .onTapGesture {
                                                viewModel.didTapBook(book: book)
                                            }
                                        }
                                    }
                                    .padding(.bottom, 16)
                                    .padding(.top, 24)
                                }
                            }
                        }
                    }
                }
            }
        .sheet(isPresented: $viewModel.showBookDetails) {
            if let bookInfoViewModel = viewModel.getBookInfoViewModel() {
                BookInfoView(viewModel: bookInfoViewModel)
                    .onDisappear {
                        viewModel.selectedBook = nil
                    }
            }
        }
        .task {
            await self.viewModel.getBooks()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

 struct DiscoverBooksList_Previews: PreviewProvider {

    static let bookDetails1 = BookDetails(title: "Capitães da areia", language: "Portugues")
    static let bookDetails2 = BookDetails(title: "Quarto de despejo", language: "Portugues")
    static let bookDetails3 = BookDetails(title: "Torto arado", language: "Portugues")

    static let bookInfo = BookInfo(id: "111", volumeInfo: bookDetails1)

    static let bookInfo2 = BookInfo(id: "112", volumeInfo: bookDetails2)

    static let bookInfo3 = BookInfo(id: "113", volumeInfo: bookDetails3)

    static let books = [bookInfo, bookInfo2, bookInfo3]

    static let title = "Livros Brasileiros"

    static let description = "Livros com a nossa cara, nossas cores e nosso jeito... Não tem como não se apaixonar! "

    static let discoverListModel = DiscoverListModel(title: "OI",
                                                     description: "OI",
                                                     imageLight: "imageLight",
                                                     imageDark: "imageDark",
                                                     imageDescription: "OI",
                                                     booksURL: [],
                                                     backgroundImageLight: "OI",
                                                     backgroundImageDark: "Oi Dark",
                                                     medal: Medal(title: "", image: "", medalType: .goal))

    static let detailDiscoverList = DiscoverBooksViewModel(selectedList: discoverListModel)

    static var previews: some View {
        DiscoverBooks(viewModel: detailDiscoverList)
    }
 }
