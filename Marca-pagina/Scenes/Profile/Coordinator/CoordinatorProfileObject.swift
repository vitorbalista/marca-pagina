import Foundation

class CoordinatorProfileObject: ObservableObject {

    @Published var profileViewModel: ProfileViewModel!
    @Published var showGoalView: Bool = false
    @Published var settingsViewModel: SettingsViewModel?

    init() {
        self.showGoalView = false
        self.profileViewModel = ProfileViewModel(self)
    }

    func open() {
        self.showGoalView = true
    }

    func closeGoal() {
        self.showGoalView = false
    }

    func openSettings() {
        settingsViewModel = SettingsViewModel(self)
    }

    func closeSettings() {
        settingsViewModel = nil
    }
}
