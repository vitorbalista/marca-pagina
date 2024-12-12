import SwiftUI

struct CoordinatorLibraryView: View {
    @ObservedObject var object: CoordinatorLibraryObject

    var body: some View {
        NavigationView {
            LibraryView(viewModel: object.libraryViewModel)
                .navigation(item: $object.books) {
                    switch object.status {
                    case .inProgress:
                        ReadingView(books: $0,
                                    mode: .vertical) { book in
                            object.openReading(book: book)
                        }
                                    .padding(.top, 16)
                                    .padding(.trailing, 16)
                                    .navigationBarTitleDisplayMode(.inline)
                    case .none:
                        CollectionView(books: $0) { book in
                            object.bookInfoViewModel = BookInfoViewModel(book: book.bookInfo)
                        }
                        .navigationTitle(object.navigationTitle)
                        .navigationBarTitleDisplayMode(.inline)
                    default:
                        CollectionView(books: $0) { book in
                            object.openInfo(book: book)
                        }
                        .navigationTitle(object.navigationTitle)
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .sheet(item: $object.readingProgressViewModel) { readingProgressViewModel in
                    ReadingProgressView(viewModel: readingProgressViewModel)
                }
                .sheet(item: $object.bookInfoViewModel) { bookInfoViewModel in
                    BookInfoView(viewModel: bookInfoViewModel)
                }
                .sheet(item: $object.annualGoalUpdateViewModel) { annualGoalViewModel in
                    AnnualGoalUpdateView(viewModel: annualGoalViewModel)
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
