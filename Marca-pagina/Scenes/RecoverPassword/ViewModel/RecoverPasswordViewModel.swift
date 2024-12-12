import Foundation
import SwiftUI

final class RecoverPasswordViewModel: ObservableObject {
    @Published var emailText = ""
    @Published var error: String?
    @Published var successRecoveringPassword = false
    @Published var viewState: ViewState = .idle
    
    func recoverPassword() {
        self.viewState = .loading
        UserUpdaterService.recoverPassword(self.emailText) { [weak self] successRecover in
            self?.successRecoveringPassword = successRecover
            if !successRecover {
                self?.error = "Esta conta não existe"
            }
            self?.viewState = .idle
        }
    }
}
