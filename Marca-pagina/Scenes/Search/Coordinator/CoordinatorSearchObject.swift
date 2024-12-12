import Foundation
import UIKit

class CoordinatorSearchObject: ObservableObject {

    @Published var searchViewModel: SearchViewModel!
    @Published var bookInfoViewModel: BookInfoViewModel?
    @Published var booksDetailedListViewModel: DiscoverBooksViewModel?

    var image: UIImage? = UIImage()

    init() {
        self.searchViewModel = SearchViewModel(coordinator: self)
    }

    func open(_ book: BookInfo) {
        if let bookInfoViewModel = LocalFileManager.shared.bookModels[book.id] {
            self.bookInfoViewModel = bookInfoViewModel
        } else {
            let bookInfoViewModel = BookInfoViewModel(book: book)
            LocalFileManager.shared.bookModels[book.id] = bookInfoViewModel
            self.bookInfoViewModel = bookInfoViewModel
        }
    }

    func open(_ discoverList: DiscoverListModel) {
        self.booksDetailedListViewModel = DiscoverBooksViewModel(selectedList: discoverList)
    }
}
