import SwiftUI

struct SearchListView: View {

    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        ZStack {
            if !viewModel.books.isEmpty {
                List {
                    ForEach(viewModel.books, id: \.id) { book in
                        BookCell(book: book)
                            .onTapGesture {
                                viewModel.goToBookInfoView(book)
                            }
                            .padding(.top, 16)
                            .listRowSeparator(.hidden)
                    }
                    if viewModel.hasMorePages {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.clear)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .onAppear {
                                    viewModel.loadMoreContent()
                                }
                            if viewModel.isLoadingPagination {
                                ProgressView()
                                    .frame(alignment: .center)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }

            if viewModel.isLoading {

                ProgressView()
                    .frame(alignment: .center)
            }
        }
    }
}

struct BookCell: View {

    var book: BookInfo

    var body: some View {

        VStack {
            HStack(alignment: .top) {
                Group {

                    if let imageLink = book.getImageLink() {
                        CacheAsyncImage(url: imageLink, scale: 1.0, transaction: .init()) { phase in

                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(alignment: .center)
                            case .failure:
                                Image("book-placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)

                            case .success(let image):
                                image
                                    .resizable()
                            @unknown default:
                                fatalError("Fail to load image")
                            }
                        }
                    } else {
                        Image("book-placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .frame(width: 79, height: 113)
                .cornerRadius(13)
                .padding(.leading, 24)

                VStack(alignment: .leading) {
                    Text(book.volumeInfo.title)
                        .style(.bold, size: 17)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 24)

                    if let author = book.volumeInfo.authors.first {
                        Text(author)
                            .style(.regular, size: 15)
                            .padding(.horizontal, 24)
                    }
                }

                Spacer()
            }
            .frame(height: 90)

            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: 1, alignment: .center)
                .foregroundColor(Constants.tertiaryLabel)
                .padding(.top, 8)
        }
    }
}

private enum Constants {
    static let tertiaryLabel = Color(uiColor: UIColor.tertiaryLabel)
}
