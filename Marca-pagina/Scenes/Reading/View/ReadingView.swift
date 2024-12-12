import SwiftUI

struct ReadingView: View {

    let books: [SavedBook]
    let mode: Axis
    let openProgressSheet: (SavedBook) -> Void

    var body: some View {

        if mode == .vertical {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ReadingBooksList(
                        elements: books,
                        frameSize: CGSize(
                            width: UIScreen.main.bounds.width * 0.91,
                            height: UIScreen.main.bounds.width * 0.79 * 0.44
                        ),
                        openProgressSheet: openProgressSheet
                    )
                    .accessibilityAddTraits(.isButton)
                    .padding(.vertical, 3)
                }
            }
            .navigationTitle("Estou Lendo")
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ReadingBooksList(
                        elements: books,
                        frameSize: CGSize(
                            width: UIScreen.main.bounds.width * 0.79,
                            height: UIScreen.main.bounds.width * 0.79 * 0.44
                        ),
                        openProgressSheet: openProgressSheet
                    )
                    .accessibilityAddTraits(.isButton)
                }
                .padding(.vertical, 4)
                .padding(.trailing, 16)
            }
        }
    }
}

struct ReadingBooksList: View {

    let elements: [SavedBook]
    let frameSize: CGSize
    let openProgressSheet: (SavedBook) -> Void

    var body: some View {
        ForEach(0..<elements.count, id: \.self) { index in
            let book = elements[index]

            ReadingComponentView(
                book: book,
                frameSize: frameSize,
                totalPages: 500
            )
            .padding(.leading, 8)
            .onTapGesture {
                openProgressSheet(book)
            }
        }
    }
}

struct EstouLendoView_Previews: PreviewProvider {
    static let books: [SavedBook] = []
    static var previews: some View {
        ReadingView(books: books, mode: .vertical) { _ in }
    }
}
