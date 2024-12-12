import Foundation
import Combine

final class LibraryViewModel: ObservableObject, ListenToUser {

    @Published private var books: [SavedBook] = [] {
        didSet {
            wantedBooks = books.filter { $0.status == .want }
            inProgressBooks = books.filter { $0.status == .inProgress }
            readBooks = books.filter { $0.status == .read }
            shouldShowInviteLong = books.isEmpty
        }
    }

    @Published var wantedBooks: [SavedBook] = []
    @Published var inProgressBooks: [SavedBook] = []
    @Published var readBooks: [SavedBook] = []
    @Published var suggestionBooks: [BookInfo] = []
    @Published var shouldShowAnnualGoal: Bool = true
    @Published var shouldShowInviteLong: Bool = true
    @Published var showBookDetails = false

    var inviteText: String {
        shouldShowInviteLong ? GoalTexts.noBookInvite : GoalTexts.fiftyPercentInvite
    }

    var explanationText: String {
        shouldShowInviteLong ? GoalTexts.noBookExplanation : GoalTexts.fiftyPercentExplanation
    }

    var bag = Set<AnyCancellable>()

    private unowned let coordinator: CoordinatorLibraryObject

    init(coordinator: CoordinatorLibraryObject) {
        self.coordinator = coordinator

        loadBooks()
        annualGoal()
        listenUserData()
    }

    func refreshData() {
        self.loadBooks()
        self.annualGoal()
    }

    func loadBooks() {
        loadSuggestionList()
        books = LocalFileManager.shared.userData.books.list
    }

    private func loadSuggestionList() {
        Task {
            let list: [DiscoverListModel] = await FirestoreManager().getData(from: "DiscoverList")
                if let list = list.first {
                    await self.getBooks(selectedList: list)
                }
        }
    }

    @MainActor
    private func getBooks(selectedList: DiscoverListModel ) async {
        for bookURL in selectedList.booksURL {
            Task {
                do {
                    let book = try await ISBNRequest().requestBook(byUrl: bookURL)
                    if let book {
                        DispatchQueue.main.async {
                            self.suggestionBooks.append(book)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    func annualGoal() {
        shouldShowAnnualGoal = LocalFileManager
            .shared
            .userData
            .annualGoal
            .shouldShowAnnualGoal
    }

    enum GoalTexts {

        static let noBookInvite = "Meta de leitura \(Calendar.current.component(.year, from: .now))"
        static let fiftyPercentInvite = "Impressionante"

        static let noBookExplanation =
        "Vamos começar? Você pode criar uma meta de livros para o ano e acompanhar seu progresso aqui!"
        static let fiftyPercentExplanation =
        "Você já leu mais da metade da sua meta e está quase conseguindo terminar! " +
        "Não deixe de marcar suas próximas leituras!"
    }
}

// MARK: - Coordinator methods
extension LibraryViewModel {
    func openCollectionForStatus(_ status: Status) {
        coordinator.open(status)
    }

    func openReadingProgress(for book: SavedBook) {
        coordinator.openReading(book: book)
    }

    func openBookInfo(for book: SavedBook) {
        coordinator.openInfo(book: book)
    }

    func openGoalAtualization() {
        coordinator.openGoalAtualization()
    }

    func openSuggestions() {
        coordinator.openSuggestions()
    }
}
