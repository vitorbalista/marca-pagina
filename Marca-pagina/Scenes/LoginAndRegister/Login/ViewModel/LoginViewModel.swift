import Foundation
import Combine

public enum ViewState {
    case idle
    case loading
}

final class LoginViewModel: NSObject, ObservableObject {
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var error = false
    @Published var currentNonce: String?
    @Published var enableButton = false
    @Published var state: ViewState = .idle

    private unowned let coordinator: CoordinatorLoginObject

    var cancellables = Set<AnyCancellable>()

    init(coordinator: CoordinatorLoginObject) {
        self.coordinator = coordinator
        super.init()

        Publishers.CombineLatest(self.$emailText, self.$passwordText)
            .sink { [weak self] emailText, passwordText in
                self?.enableButton = emailText.trim() != "" && passwordText.trim() != ""
            }
            .store(in: &self.cancellables)
    }

    func goToRegister() {
        self.coordinator.openRegisterView()
    }

    func goToRecover() {
        self.coordinator.openRecoverView()
    }
}
