import Foundation

enum ProgressOption: String {
    case percent = "Porcentagem"
    case hours = "Horas"
    case pages = "Páginas"
}

enum TextFieldType {
    case progress
    case total
}

final class ReadingProgressViewModel: ObservableObject, Identifiable {
    var progressOptions: [ProgressOption] = [.percent, .pages, .hours]

    @Published var progressNumber: String = ""
    @Published var totalNumber: String = ""
    @Published var lastEditedDate: Date?
    @Published var book: SavedBook!
    @Published var selectedProgressOption: ProgressOption = .pages {
        didSet { didSetSelectedProgressOption() }
    }

    private unowned let coordinator: CoordinatorLibraryObject

    init(coordinator: CoordinatorLibraryObject) {
        self.coordinator = coordinator
    }

    func isProgressGreaterThanTotal() -> Bool {
        let progressInt = Float(progressNumber) ?? 0
        let totalInt = Float(totalNumber) ?? (selectedProgressOption == .percent ? 100 : 0)
        return progressInt > totalInt
    }

    func clearTexts() {
        progressNumber = ""
        totalNumber = ""
    }

    func filterText(_ value: String, type: TextFieldType) {
        let filtered = value.filter { "0123456789.".contains($0) }
        if filtered != value {
            if type == .progress {
                progressNumber = filtered
            } else {
                totalNumber = filtered
            }
        }
    }

    func didSetSelectedProgressOption() {
        clearTexts()
        self.totalNumber = getNumberOfPages()
    }

    func getNumberOfPages() -> String {
        var string = ""

        switch self.selectedProgressOption {
        case .pages:
            let number = self.book?.bookInfo.getNumberOfPages()
            string = "\(String(describing: number))"
            return string
        case .hours:
            let hours = self.book?.bookInfo.getNumberOfHours()
            string = "\(String(describing: hours))"
            return string
        default:
            return string
        }
    }

    func dismiss() {
        coordinator.dismissReadingProgressView()
    }

    func saveBookProgress() {
        book
            .updatePagesRead(to: Int(progressNumber))
        book
            .bookInfo
            .volumeInfo
            .updateTotalNumber(for: selectedProgressOption, to: Int(totalNumber))

        coordinator.saveProgress(of: book)
    }
}
