import Foundation
import Combine

final class AnnualGoalUpdateViewModel: ObservableObject, Identifiable {

    @Published var annualGoalValue: String = ""
    @Published var shouldShowAnnualGoal: Bool = true

    private var bag = Set<AnyCancellable>()

    private unowned let coordinator: CoordinatorLibraryObject

    init(coordinator: CoordinatorLibraryObject) {
        self.coordinator = coordinator

        $annualGoalValue
            .map { Int($0) ?? 0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { self.annualGoalValue = self.filterAnnualGoal($0) })
            .store(in: &bag)
    }

    func dismiss() {
        coordinator.dismissAnnualGoalView()
    }

    func saveAnnualGoal() {
        let annualGoal = AnnualGoal(
            value: Int(annualGoalValue) ?? 0,
            shouldShowAnnualGoal: shouldShowAnnualGoal
        )

        coordinator.saveAnnualGoal(value: annualGoal)
    }

    func filterAnnualGoal(_ value: Int) -> String {
        value ==  0 ? "" : String(value)
    }
}
