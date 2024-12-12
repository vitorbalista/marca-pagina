import Foundation
import UIKit
import Combine

final class SearchViewModel: ObservableObject {

    @Published var searchText = ""
    @Published var books: [BookInfo] = []
    @Published var covers: [UIImage] = []
    @Published var discoverListViewModel: DiscoverListViewModel!
    @Published var isLoading: Bool = false
    @Published var isLoadingPagination: Bool = false

    private let isbnRequest = ISBNRequest()

    private unowned let coordinator: CoordinatorSearchObject

    private var bag = Set<AnyCancellable>()

    private var currentPage = 0
    private let pageSize = 10
    private var totalItems: Int?

    var hasMorePages: Bool {
        pageSize * (currentPage + 1) <= (totalItems ?? -1)
    }

    init(coordinator: CoordinatorSearchObject) {
        self.coordinator = coordinator
        self.discoverListViewModel = DiscoverListViewModel(coordinator: self.coordinator)

        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                if text.trim() != "" {
                    self?.getBookByName()
                }
            })
            .store(in: &bag)
    }

    func goToBookInfoView(_ book: BookInfo) {
        coordinator.open(book)
    }

    func getBookByName() {

        isLoading = true
        isbnRequest.request(byBookName: self.searchText) { response in

            DispatchQueue.main.async { [weak self] in

                self?.isLoading = false
                self?.books = response.items
                self?.totalItems = response.totalItems
            }
        }
    }

    func saveBook(book: BookInfo, bookInfoViewModel: BookInfoViewModel) {
        let bookInfo = book.getBookInfo()
        LocalFileManager
            .shared
            .add(book: SavedBook(bookInfo: bookInfo,
                                 status: bookInfoViewModel.status ?? .inProgress,
                                 coments: "",
                                 rating: 10,
                                 favorite: false,
                                 pagesRead: 0,
                                 startDate: .now,
                                 lastUpdateDate: .now,
                                 endDate: nil)
            )
    }

    func openList(discoverList: DiscoverListModel) {
        coordinator.open(discoverList)
    }

    func loadMoreContent() {

        currentPage += 1
        isLoadingPagination = true
        isbnRequest.request(byBookName: searchText,
                            page: currentPage,
                            pageSize: pageSize) { response in

            DispatchQueue.main.async { [weak self] in
                self?.isLoadingPagination = false
                self?.totalItems = response.totalItems
                self?.books.append(contentsOf: response.items)
            }
        }
    }
}
