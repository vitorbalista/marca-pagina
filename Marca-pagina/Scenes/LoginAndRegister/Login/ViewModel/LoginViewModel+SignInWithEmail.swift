import Foundation
import FirebaseAuth
import Firebase

extension LoginViewModel {
    func signInWithEmail() {
        self.state = .loading
        Auth
            .auth()
            .signIn(withEmail: emailText, password: passwordText) { authResult, error in
                if let user = authResult?.user {
                    print("Nice! You're now signed in as \(user.uid), email: \(user.email ?? "unkown")")
                    self.getUserWithID(userID: user.uid)
                    return
                }

                if let error = error {
                    self.error = true
                    self.state = .idle
                    print(error.localizedDescription)
                    return
                }
            }
    }

    func getUserWithID(userID: String) {
        let firebaseManager = FirestoreManager()
        Task {
            let user: UserData? = await firebaseManager.getData(from: "UserData", documentID: userID)
            if let user = user {
                LocalFileManager.shared.updateUser(to: user)
            }

            DispatchQueue.main.async {
                self.state = .idle
            }
        }
    }
}
