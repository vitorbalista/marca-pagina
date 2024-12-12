import SwiftUI

struct BookInfoView: View {

    @ObservedObject var viewModel: BookInfoViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    BookDetailedView(bookInfo: viewModel.book,
                                     score: 4,
                                     imageHeight: 378,
                                     imageWidth: 250)
                    .padding(.top, 25)
                    .padding([.leading, .trailing])

                    HStack {
                        BookStatusDropDown(bookInfoViewModel: viewModel)

                        Button {
                            self.viewModel.isFavorite.toggle()
                        } label: {
                            Image(systemName: self.viewModel.isFavorite == true ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(ColorAsset.pink.primary)
                                .padding(.leading, 24)
                        }
                    }
                    .padding(.top, 29)

                    Rectangle()
                        .frame(height: 1, alignment: .center)
                        .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
                        .padding(.top, 33)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)

                    DescriptionComponents(bookInfo: viewModel.book,
                                          lineLimit: 4)
                    .padding([.leading, .trailing], 35)
                    .padding(.top, 18)

                    if viewModel.authors.count > 1 {
                        AuthorList(
                            cellSize: CGSize(width: 150, height: 76),
                            listHeight: 80,
                            authors: viewModel.authors
                        )
                        .padding([.leading, .trailing], 35)
                        .padding(.top, 40)
                    }

                    if !viewModel.genres.isEmpty {
                        GenreView(genres: viewModel.genres,
                                  size: CGSize(width: 45, height: 45),
                                  headerHeight: 24)
                        .padding([.leading, .trailing], 35)
                        .padding(.top, 24)
                    }

                    ReportButton()
                        .padding(.top, 32)

                    // TODO: - Get year in response and fix isbn
                    // TODO: - Fix force unwraps
                    MoreInfoView(bookInfo: viewModel.book)
                    .padding([.leading, .trailing], 35)
                    .padding(.top, 40)

                    Rectangle()
                        .frame(height: 1, alignment: .center)
                        .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
                        .padding(.top, 31)
                        .padding([.leading, .trailing])

                    RatingView(name: viewModel.username,
                               date: viewModel.ratingDate,
                               rating: viewModel.rating,
                               comment: viewModel.comment)
                    .padding([.leading, .trailing], 35)
                    .padding([.top, .bottom], 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(ColorAsset.pink.primary)
                }

                ToolbarItem(placement: .principal) {
                    Text(viewModel.book.getBookTitle())
                        .style(.bold, size: 22)
                }
            }.edgesIgnoringSafeArea(.top)
        }
    }
}

struct BookInfoView_Previews: PreviewProvider {
    static let viewModel = BookInfoViewModel(book: bookInfo)
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
        BookInfoView(viewModel: viewModel)
    }
}
