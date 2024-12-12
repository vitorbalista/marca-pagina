import Foundation

class CoordinatorLibraryObject: ObservableObject {

    @Published var libraryViewModel: LibraryViewModel!
    @Published var readingProgressViewModel: ReadingProgressViewModel?
    @Published var bookInfoViewModel: BookInfoViewModel?
    @Published var annualGoalUpdateViewModel: AnnualGoalUpdateViewModel?
    @Published var books: [SavedBook]?
    @Published var status: Status?
    private(set) var navigationTitle: String = ""

    init() {
        self.libraryViewModel = LibraryViewModel(coordinator: self)
    }

    func open(_ status: Status) {
        switch status {
        case .want:
            self.books = libraryViewModel.wantedBooks
            self.status = .want
            self.navigationTitle = "Quero Ler"
        case .inProgress:
            self.books = libraryViewModel.inProgressBooks
            self.status = .inProgress
            self.navigationTitle = "Estou Lendo"
        case .read:
            self.books = libraryViewModel.readBooks
            self.status = .read
            self.navigationTitle = "Já Li"
        }
    }

    func openReading(book: SavedBook) {
        let readingProgressViewModel = ReadingProgressViewModel(coordinator: self)
        readingProgressViewModel.book = book

        self.readingProgressViewModel = readingProgressViewModel
    }

    func openInfo(book: SavedBook) {

        self.bookInfoViewModel = BookInfoViewModel(book: book.bookInfo, status: book.status)
    }

    func dismissReadingProgressView() {
        self.readingProgressViewModel = nil
    }

    func saveProgress(of book: SavedBook) {
        LocalFileManager
            .shared
            .update(book: book)

        self.readingProgressViewModel = nil
    }

    func openGoalAtualization() {
        let annualGoalViewModel = AnnualGoalUpdateViewModel(coordinator: self)

        let annualGoal = LocalFileManager.shared.userData.annualGoal

        annualGoalViewModel.annualGoalValue = String(annualGoal.value)
        annualGoalViewModel.shouldShowAnnualGoal = annualGoal.shouldShowAnnualGoal

        self.annualGoalUpdateViewModel = annualGoalViewModel
    }

    func dismissAnnualGoalView() {
        self.annualGoalUpdateViewModel = nil
    }

    func saveAnnualGoal(value: AnnualGoal) {
        LocalFileManager
            .shared
            .updateAnnualGoal(to: value)

        self.annualGoalUpdateViewModel = nil
    }

    func openSuggestions() {
        var suggestions: [SavedBook] = []
        for book in libraryViewModel.suggestionBooks {
            suggestions.append(SavedBook(bookInfo: book, status: .want, coments: "", rating: 0.0, favorite: false))
        }
        self.books = suggestions
        self.status = .none
        self.navigationTitle = "Sugestões"

    }
}
