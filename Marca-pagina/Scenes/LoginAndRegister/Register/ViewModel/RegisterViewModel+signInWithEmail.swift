import Foundation
import FirebaseAuth

extension RegisterViewModel {
    func createUser() {
        self.state = .loading
        Auth
            .auth()
            .createUser(withEmail: emailText, password: passwordText) { authResult, error in
                if let user = authResult?.user {
                    print("Nice! You're account as create as \(user.uid), email: \(user.email ?? "unkown")")
                    self.createUserInFirebase(user: user)
                    self.state = .idle
                }

                if let error = error {
                    print(error.localizedDescription)
                }
            }
    }

    func createUserInFirebase(user: User) {
        let userData = UserData(
            photo: "photo",
            name: self.nameText,
            books: SavedBooks(list: []),
            medals: [],
            annualGoal: AnnualGoal(value: 0, shouldShowAnnualGoal: true),
            userID: user.uid,
            challenges: []
        )

        LocalFileManager.shared.updateUser(to: userData)
        let firebaseManager = FirestoreManager()
        firebaseManager.createUser(userData: userData)
    }
}
