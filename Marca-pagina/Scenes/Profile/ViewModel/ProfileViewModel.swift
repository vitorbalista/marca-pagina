import Foundation
import Combine

final class ProfileViewModel: ObservableObject, ListenToUser {

    @Published var selectedFrequency = SelectedFrequency.monthly
    @Published var goal: String = ""

    @Published var data: ReadingGoals!

    @Published var userName = LocalFileManager.shared.userData.name
    @Published var readBooks = 0
    @Published var wantBooks = 0
    @Published var readingBooks = 0

    var bag: Set<AnyCancellable>

    private unowned let coordinator: CoordinatorProfileObject

    init(_ coordinator: CoordinatorProfileObject) {
        self.coordinator = coordinator
        self.bag = Set<AnyCancellable>()
        self.data = ReadingGoals(months: self.nextSixDates())
        self.wantBooks = getNumberOfBooksForStatus(status: .want)
        self.readBooks = getNumberOfBooksForStatus(status: .read)
        self.readingBooks = getNumberOfBooksForStatus(status: .inProgress)
        self.listenUserData()
    }

    func save() {
        data = ReadingGoals(months: nextSixDates(),
                            goals: Array(repeating: Int(goal) ?? 12, count: 6))
        coordinator.closeGoal()
    }

    func refreshData() {
        self.wantBooks = getNumberOfBooksForStatus(status: .want)
        self.readBooks = getNumberOfBooksForStatus(status: .read)
        self.readingBooks = getNumberOfBooksForStatus(status: .inProgress)
        if self.userName != LocalFileManager.shared.userData.name {
            self.userName = LocalFileManager.shared.userData.name
        }
    }

    func getBookCount(by status: Status) -> Int {
        switch status {
        case .want:
            return self.wantBooks
        case .inProgress:
            return self.readingBooks
        case .read:
            return self.readBooks
        }
    }

    private func getNumberOfBooksForStatus(status: Status) -> Int {
        let books = LocalFileManager.shared.userData.books.list
        return books.filter({ $0.status == status}).count
    }

    func nextSixDates() -> [String] {
        var nextSixDates: [String] = []

        for index in 0...5 {
            switch selectedFrequency {
            case .daily:
                nextSixDates.append(nextMonths(step: index, type: .day))
            case .weekly:
                nextSixDates.append(nextMonths(step: index, type: .weekday))
            case .monthly:
                nextSixDates.append(nextMonths(step: index, type: .month))
            }
        }

        return nextSixDates
    }

    func nextMonths(step: Int, type: Calendar.Component) -> String {
        let date = Calendar.current.date(byAdding: type, value: step, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LL"

        guard let date = date else { return "" }
        let datePrefix = dateFormatter.string(from: date).prefix(3)

        return String(datePrefix)
    }

    enum SelectedFrequency: String, CaseIterable {
        case daily = "Diária"
        case weekly = "Semanal"
        case monthly = "Mensal"
    }

    func goToGoalViews() {
        coordinator.open()
    }
}
