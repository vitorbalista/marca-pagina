import Foundation
import SwiftUI

enum DiscoverBooksState {
    case loading
    case idle
}

final class DiscoverBooksViewModel: ObservableObject {

    @Published var showBookDetails = false
    @Published private(set) var books: [BookInfo] = []
    @Published private(set) var viewState: DiscoverBooksState = .loading

    var booksViewModels: [String: BookInfoViewModel] = [:]
    var selectedBook: BookInfo?

    let selectedList: DiscoverListModel!

    init(selectedList: DiscoverListModel) {
        self.selectedList = selectedList
    }

    @MainActor
    func getBooks() async {
        guard books.isEmpty else { return }

        for bookURL in selectedList.booksURL {
            Task {
                do {
                    let book = try await ISBNRequest().requestBook(byUrl: bookURL)
                    if let book {
                        DispatchQueue.main.async {
                            self.books.append(book)
                        }
                    }
                    self.viewState = .idle
                } catch {
                    print(error)
                }
            }
        }
    }

    func imageURL(colorScheme: ColorScheme) -> String {
        
        var imageURL: String {
            if colorScheme == .dark {
                let darkImage = selectedList.backgroundImageDark
                return darkImage
            } else {
                let lightImage = selectedList.backgroundImageLight
                return lightImage
            }
        }

        return imageURL
    }

    func getBookInfoViewModel(book: BookInfo) -> BookInfoViewModel {
        let fileManager = LocalFileManager.shared

        let loaded: UserData? = fileManager
            .load(fileName: LocalPath.fileName.rawValue,
                  folderName: LocalPath.folderName.rawValue)

        if let viewModel = self.booksViewModels[book.id] {
            return viewModel
        }

        if let loaded {
            let savedBook = loaded.books.list.first { $0.bookInfo.id == book.id }

            guard let selectedBook = savedBook else {
                let viewModel = BookInfoViewModel(book: book)
                self.booksViewModels[book.id] = viewModel
                return viewModel
            }
            let bookViewModel = BookInfoViewModel(book: selectedBook.bookInfo,
                                                  status: selectedBook.status)
            self.booksViewModels[book.id] = bookViewModel
            return bookViewModel
        }
        let viewModel = BookInfoViewModel(book: book)
        self.booksViewModels[book.id] = viewModel
        return viewModel
    }

    func getBookInfoViewModel() -> BookInfoViewModel? {
        let fileManager = LocalFileManager.shared
        guard let book = self.selectedBook else { return nil }

        if let viewModel = self.booksViewModels[book.id] {
            return viewModel
        }

        let loaded: UserData? = fileManager
            .load(fileName: LocalPath.fileName.rawValue,
                  folderName: LocalPath.folderName.rawValue)

        if let viewModel = self.booksViewModels[book.id] {
            return viewModel
        }

        if let loaded {
            let savedBook = loaded.books.list.first { $0.bookInfo.id == book.id }

            guard let selectedBook = savedBook else {
                let viewModel = BookInfoViewModel(book: book)
                self.booksViewModels[book.id] = viewModel
                return viewModel
            }

            let bookViewModel = BookInfoViewModel(book: selectedBook.bookInfo,
                                                  status: selectedBook.status)
            self.booksViewModels[book.id] = bookViewModel
            return bookViewModel
        }

        let viewModel = BookInfoViewModel(book: book)
        self.booksViewModels[book.id] = viewModel
        return viewModel
    }

    func didTapBook(book: BookInfo) {
        self.selectedBook = book
        self.showBookDetails.toggle()
    }
}
