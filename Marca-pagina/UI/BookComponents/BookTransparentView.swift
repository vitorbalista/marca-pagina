import SwiftUI

struct BookTransparentView: View {

    @ObservedObject var bookInfoViewModel: BookInfoViewModel

    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.init(uiColor: UIColor.systemBackground))
                    .opacity(0.8)
                    .shadow(color: Color.black.opacity(0.25),
                            radius: 4,
                            x: 0,
                            y: 4)
                HStack(spacing: 16) {
                    ZStack {
                        AsyncImage(url: bookInfoViewModel.book.getImageLink()) { image in
                            image
                                .resizable()
                                .cornerRadius(12)
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .frame(width: 87, height: 134)
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(bookInfoViewModel.book.getBookTitle())
                                .style(.bold, size: 17)
                                .fixedSize(horizontal: false,
                                           vertical: true)
                                .foregroundColor(Color.init(uiColor: UIColor.label))
                            if let author = bookInfoViewModel.book.getAuthors().first {
                                Text(author)
                                    .style(.regular, size: 15)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 4)
                        Spacer()
                        BookStatusDropDown(bookInfoViewModel: bookInfoViewModel)
                            .frame(height: 43)
                            .padding(.bottom, 4)

                    }
                    .padding(.top, 12)
                }
                .padding(.leading, 16)
                .padding(.trailing, 20)
                .padding(.vertical, 12)
            }
    }
}

 struct BookTransparentView_Previews: PreviewProvider {
    static let bookDetails = BookDetails(title: "melancia", language: "Portugues")
    static let bookInfo = BookInfo(id: "123", volumeInfo: bookDetails)
    static let viewModel: BookInfoViewModel = BookInfoViewModel(book: bookInfo)

    static var previews: some View {
        BookTransparentView(bookInfoViewModel: viewModel)
    }
 }
