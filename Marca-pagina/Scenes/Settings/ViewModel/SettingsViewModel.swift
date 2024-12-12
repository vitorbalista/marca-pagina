import Foundation

final class SettingsViewModel: ObservableObject, Identifiable {
    @Published var showReadingGoal: Bool = false
    @Published var showPagesReadChart: Bool = false

    @Published var allowNotifications: Bool = false
    @Published var activateDarkMode: Bool = false
    @Published var useDeviceSettings: Bool = false

    private unowned let coordinator: CoordinatorProfileObject

    init(_ coordinator: CoordinatorProfileObject) {
        self.coordinator = coordinator
    }

    func openEditProfile() { }
    func openChangePassword() { }
    func openHelpCenter() { }

    func closeSetting() {
        self.coordinator.closeSettings()
    }
}
