import Foundation
import Combine
import CryptoKit
import AuthenticationServices

final class RegisterViewModel: NSObject, ObservableObject {

    @Published var nameText: String = ""
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var confirmationPasswordText: String = ""
    @Published var state: ViewState = .idle

    @Published var currentNonce: String?
    @Published private(set) var passwordInvalid = false
    @Published private(set) var confirmationPasswordInvalid = false
    @Published private(set) var emailIsInvalid = false

    @Published var enableButton = false

    private(set) var passwordErros: [String] = []
    private(set) var confirmationPasswordErrors: [String] = []

    var cancellables = Set<AnyCancellable>()

    init(nameText: String = "",
         emailText: String = "",
         passwordText: String = "",
         confirmationPasswordText: String = "",
         passwordInvalid: Bool = false,
         confirmationPasswordInvalid: Bool = false) {
        self.nameText = nameText
        self.emailText = emailText
        self.passwordText = passwordText
        self.confirmationPasswordText = confirmationPasswordText
        self.passwordInvalid = passwordInvalid
        self.confirmationPasswordInvalid = confirmationPasswordInvalid

        super.init()
        setupBinding()
    }

    private func setupBinding() {

        self.$passwordText
            .sink { password in
                if password.trim() == "" {
                    self.passwordInvalid = false
                    self.passwordErros = []
                }
            }
            .store(in: &self.cancellables)

        self.$confirmationPasswordText.sink { confirmationPassword in
            if confirmationPassword.trim() == "" {
                self.confirmationPasswordInvalid = false
                self.confirmationPasswordErrors = []
            }
        }
        .store(in: &self.cancellables)

        self.$emailText.debounce(for: .seconds(2), scheduler: RunLoop.main).sink { email in
            self.verifyEmailText(email)
        }
        .store(in: &self.cancellables)

        self.$passwordText.debounce(for: .seconds(1),
                                    scheduler: RunLoop.main).sink { password in
            self.validatePasswordText(password, true)
        }
                                    .store(in: &self.cancellables)

        self.$confirmationPasswordText.debounce(for: .seconds(1),
                                                scheduler: RunLoop.main).sink { confirmationPassword in
            self.validatePasswordText(confirmationPassword, false)
        }
                                                .store(in: &self.cancellables)

        Publishers.CombineLatest4(self.$passwordText, self.$confirmationPasswordText, self.$emailText, self.$nameText)
            .sink { [weak self] userPassword, userConfirmationPassword, userEmail, userNameText in
                guard let self = self else { return }
                let userPasswordIsValid = self.isValidPassword(userPassword)
                let confirmationPasswordIsValid = self.isValidPassword(userConfirmationPassword) && (userPassword == userConfirmationPassword)
                let isEmailValid = self.isValidEmail(userEmail)
                let nameIsValid = userNameText.trim().count > 2

                self.enableButton = userPasswordIsValid && confirmationPasswordIsValid && isEmailValid && nameIsValid
            }
            .store(in: &self.cancellables)
    }

    private func isValidPassword(_ passwordToVerify: String) -> Bool {
        // least one letter,
        // least one digit
        //  min 8 characters total
        let password = passwordToVerify.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z]?)(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@", passwordRegx)
        return passwordCheck.evaluate(with: password)
    }

    private func getMissingValidation(str: String) -> [String] {
        var errors: [String] = []

        if !NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: str) {
            errors.append("Pelo menos um digito.")
        }

        if !NSPredicate(format: "SELF MATCHES %@", ".*[A-Za-z]+.*").evaluate(with: str) {
            errors.append("Pelo menos uma letra.")
        }

        if str.count < 8 {
            errors.append("Mínimo de 8 caracteres")
        }
        return errors
    }

    private func validateName() -> Bool {
        return self.nameText.trim().count > 2
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func validatePasswordText(_ text: String, _ isPassword: Bool) {
        if text.trim() != "" {
            let isValid = self.isValidPassword(text)
            if isPassword {
                self.passwordInvalid = !isValid
                if !isValid {
                    let errors = self.getMissingValidation(str: text)
                    self.passwordErros = errors
                    return
                }
                self.passwordInvalid = false
                self.passwordErros = []
                return
            }
            self.confirmationPasswordInvalid = !isValid
            if !isValid {
                let errors = self.getMissingValidation(str: text)
                self.confirmationPasswordErrors = errors
                return
            }
            self.confirmationPasswordInvalid = false
            self.confirmationPasswordErrors = []
            return
        }
        if isPassword {
            self.passwordErros = []
            self.passwordInvalid = false
            return
        }
        self.confirmationPasswordErrors = []
        self.confirmationPasswordInvalid = false
    }

    func verifyEmailText(_ email: String) {
        if email.trim() != "" {
            let isValid = self.isValidEmail(email)
            if !isValid {
                self.emailIsInvalid = true
                return
            }
            self.emailIsInvalid = false
            return
        }
        self.emailIsInvalid = false
    }
}
