import UIKit
import Foundation

final class BookInfoViewModel: ObservableObject, Identifiable {

    @Published var book: BookInfo
    @Published var status: Status?
    @Published var isFavorite: Bool = false
    @Published var selectedStatus: String = "Adicionar à lista"

    let authors: [String]
    let genres: [Genre]
    let username: String
    let ratingDate: String
    let rating: Int?
    let comment: String?

    private let descriptionRequest = DescriptionRequest()
    private let isbnRequest = ISBNRequest()

    init(book: BookInfo, status: Status? = nil) {
        self.book = book
        self.status = status
        self.authors = book.getAuthors()
        self.genres = Genre.presentGenres(give: book.getCategories() ?? [])
        self.username = "UserName"
        self.ratingDate = "Teste"
        self.rating = nil
        self.comment = nil
    }

    func setSelectedStatusText(for status: Status) -> String {
        switch status {
        case .want:
            return "Quero ler"
        case .inProgress:
            return "Estou lendo"
        case .read:
            return "Já li"
        }
    }

    func setStatusWhenPickerChange(for selectedStatus: String) -> Status? {
        switch selectedStatus {
        case "Quero ler":
            return .want
        case "Estou lendo":
            return .inProgress
        case "Já li":
            return .read
        default:
            return nil
        }
    }

    func saveBook() {
        let bookInfo = self.book.getBookInfo()
        if let status = self.status {
            let savedBook = SavedBook(bookInfo: bookInfo,
                                      status: status,
                                      coments: "",
                                      rating: 10,
                                      favorite: false,
                                      pagesRead: 0,
                                      startDate: .now,
                                      lastUpdateDate: .now,
                                      endDate: nil)
            LocalFileManager
                .shared
                .add(book: savedBook)

            FirestoreManager()
                .setData(userData: LocalFileManager.shared.userData)

            return
        }
        
        LocalFileManager.shared.deleteBook(byId: bookInfo.id)
        FirestoreManager()
            .setData(userData: LocalFileManager.shared.userData)
    }

    func setBook(_ book: BookInfo) {
        self.book = book
    }
}
