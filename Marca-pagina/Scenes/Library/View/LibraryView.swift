import SwiftUI

struct LibraryView: View {

    @ObservedObject var viewModel: LibraryViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                if !viewModel.inProgressBooks.isEmpty {
                    VStack {
                        HeaderViewWithButton(imageName: Status.inProgress.image, foregroundColor: Status.inProgress.foregroundColor, text: "Estou Lendo") {
                            viewModel.openCollectionForStatus(.inProgress)
                        }
                        .padding(.horizontal, 16)
                        ReadingView(
                            books: viewModel.inProgressBooks,
                            mode: .horizontal
                        ) { book in
                            viewModel.openReadingProgress(for: book)
                        }
                        .padding(.leading, 8)
                    }
                }
                if !viewModel.wantedBooks.isEmpty {
                    VStack(spacing: 16) {
                        HeaderViewWithButton(imageName: Status.want.image, foregroundColor: Status.want.foregroundColor, text: "Quero Ler") {
                            viewModel.openCollectionForStatus(.want)
                        }
                        .padding(.horizontal, 16)

                        ReadingListView(
                            status: .want,
                            height: 150,
                            books: viewModel.wantedBooks
                        ) { book in
                            viewModel.openBookInfo(for: book)
                        }
                        .padding(.horizontal, 16)
                    }
                }
                if !viewModel.readBooks.isEmpty {
                    VStack(spacing: 16) {
                        HeaderViewWithButton(imageName: Status.read.image, foregroundColor: Status.read.foregroundColor, text: "Lidos") {
                            viewModel.openCollectionForStatus(.read)
                        }
                        .padding(.horizontal, 16)
                        ReadingListView(
                            status: .read,
                            height: 150,
                            books: viewModel.readBooks
                        ) { book in
                            viewModel.openBookInfo(for: book)
                        }
                        .padding(.horizontal, 16)
                    }
                }

                AnnualGoalView(viewModel: viewModel)
            }
        }
        .padding(.top, 24)
        .navigationTitle("Biblioteca")
        .navigationBarTitleDisplayMode(.large)
    }
}
