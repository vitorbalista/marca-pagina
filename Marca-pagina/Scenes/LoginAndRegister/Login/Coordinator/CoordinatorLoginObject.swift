import Foundation

class CoordinatorLoginObject: ObservableObject {

    @Published var registerViewModel: RegisterViewModel?
    @Published var recoverViewModel: RecoverPasswordViewModel?

    func openRegisterView() {
        self.registerViewModel = RegisterViewModel()
    }

    func openRecoverView() {
        self.recoverViewModel = RecoverPasswordViewModel()
    }
}
