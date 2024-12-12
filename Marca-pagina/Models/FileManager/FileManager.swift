import Foundation

public protocol LocalFileManagerProtocol {

    func save<ObjectType: Encodable>(object: ObjectType,
                                     fileName: String,
                                     folderName: String) throws
    func load<ReturnType: Decodable>(fileName: String, folderName: String) -> ReturnType?
}

final class LocalFileManager: ObservableObject {

    static let shared = LocalFileManager()
    var bookModels: [String: BookInfoViewModel] = [:]
    var discoverLists: [DiscoverListModel] = []

    @Published private(set) var userData = UserData(
        photo: "photo",
        name: "",
        books: SavedBooks(list: []),
        medals: [Medal](),
        annualGoal: AnnualGoal(value: 0, shouldShowAnnualGoal: true),
        userID: "",
        challenges: []
    )

    public init() {}
}

// MARK: - Funções para atualizar os dados do usuário

extension LocalFileManager {

    func updateUser(to value: UserData) {
        LocalFileManager.shared.userData = value

        baseSave(calledBy: .updateUser)
    }

    func add(book: SavedBook) {
        var booksList = LocalFileManager
            .shared
            .userData
            .books
            .list
            .filter { $0.bookInfo.id != book.bookInfo.id }

        booksList.append(book)

        LocalFileManager.shared.userData.books.list = booksList

        if let bookModel = LocalFileManager.shared.bookModels[book.bookInfo.id] {
            bookModel.status = book.status
        } else {
            let bookModel = BookInfoViewModel(book: book.bookInfo, status: book.status)
            LocalFileManager.shared.bookModels[book.bookInfo.id] = bookModel
        }

        baseSave(calledBy: .addBook)
    }

    func addMedals(_ medals: [Medal]) {
        var userMedals = LocalFileManager.shared.userData.medals
        userMedals += medals

        LocalFileManager.shared.userData.medals = userMedals
        baseSave(calledBy: .updateMedal)
    }

    func update(book: SavedBook) {
        if let row = LocalFileManager
            .shared
            .userData
            .books
            .list
            .firstIndex(where: {$0.bookInfo.id == book.bookInfo.id}) {
            LocalFileManager.shared.userData.books.list[row] = book
        }

        baseSave(calledBy: .updateBook)
    }

    func delete(book: SavedBook) {

        let data = LocalFileManager.shared.userData.books.list.filter { savedBook in
            savedBook.bookInfo.id != book.bookInfo.id
        }

        LocalFileManager.shared.userData.books.list = data

        baseSave(calledBy: .deleteBook)
    }

    func deleteBook(byId: String) {

        let data = LocalFileManager.shared.userData.books.list.filter { savedBook in
            savedBook.bookInfo.id != byId
        }

        LocalFileManager.shared.userData.books.list = data

        if LocalFileManager.shared.bookModels[byId] != nil {
            LocalFileManager.shared.bookModels.removeValue(forKey: byId)
        }

        baseSave(calledBy: .deleteBookById)
    }

    func updateAnnualGoal(to: AnnualGoal) {
        LocalFileManager.shared.userData.annualGoal = to

        baseSave(calledBy: .updateAnnualGoal)
    }

    func addChallenge(challenge: Challenge) {
        let challengeList = LocalFileManager
            .shared
            .userData
            .challenges
            .filter { $0.title == challenge.title }

        if challengeList.isEmpty {
            LocalFileManager.shared.userData.challenges.append(challenge)

            baseSave(calledBy: .addChallenge)
        }
    }

    func deleteChallenge(challenge: Challenge) {
        let challengeList = LocalFileManager
            .shared.userData
            .challenges
            .filter { savedChallenge in
                savedChallenge.title != challenge.title
            }

        LocalFileManager.shared.userData.challenges = challengeList

        baseSave(calledBy: .deleteChallenge)
    }

    private func baseSave(calledBy: SaveCalledBy) {
        do {
            try save(object: LocalFileManager.shared.userData,
                     fileName: LocalPath.fileName.rawValue,
                     folderName: LocalPath.folderName.rawValue)
        } catch {
            print(calledBy.rawValue + "\(error)")
        }
    }

    private enum SaveCalledBy: String {
        case updateUser = "Error updating user: "
        case addBook = "Error adding book: "
        case updateBook = "Error updating book: "
        case deleteBook = "Error deleting book: "
        case deleteBookById = "Error deleting book by id: "
        case updateAnnualGoal = "Error adding annual goal: "
        case addChallenge = "Error adding challenge: "
        case deleteChallenge = "Error deleting challenge: "
        case updateMedal = "Error updating medal: "
    }
}
