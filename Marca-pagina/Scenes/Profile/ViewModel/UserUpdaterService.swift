import Foundation
import FirebaseAuth

final class UserUpdaterService {
    static func updateUserEmail(_ newEmail: String) {
        guard let user = Auth.auth().currentUser else { return }
        user.updateEmail(to: newEmail) { err in
            if err != nil {
                print("Erro ao atualizar o email")
            }
        }
    }

    static func updatePassword(_ oldPassword: String, _ newPassword: String) {
        guard let user = Auth.auth().currentUser else { return }

        let emailAuthProvider =  EmailAuthProvider
            .credential(withEmail: user.email ?? "", password: oldPassword)

        user.reauthenticate(with: emailAuthProvider) { _, err in
            user.updatePassword(to: newPassword) { err in
                if err != nil {
                    print("Erro ao atualizar a senha")
                }
            }
        }
    }

    static func updateName(_ newName: String) {
        var userData = LocalFileManager.shared.userData
        userData.name = newName
        FirestoreManager().setData(userData: userData)
    }

    static func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }

    static func recoverPassword(_ email: String, completion: @escaping (Bool) -> Void ) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let _ = error {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
