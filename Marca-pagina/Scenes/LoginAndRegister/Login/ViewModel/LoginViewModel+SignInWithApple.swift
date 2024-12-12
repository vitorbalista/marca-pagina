import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAuth
import Foundation

// MARK: - Métodos para serem vistos pela View
extension LoginViewModel {
    func handleSignInWithApple() {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self

        authorizationController.performRequests()
    }

    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce

        return request
    }

    private func getAppleUserWithID(user: User) {
        let firebaseManager = FirestoreManager()
        Task {
            let fetchedUser: UserData? = await firebaseManager.getData(from: "UserData", documentID: user.uid)
            if let fetchedUser = fetchedUser {
                LocalFileManager.shared.updateUser(to: fetchedUser)
            } else {
                self.createUserInFirebase(user: user)
            }
            self.state = .idle
        }
    }

    private func createUserInFirebase(user: User) {
        let userData = UserData(
            photo: "photo",
            name: user.displayName ?? "N/A",
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

// MARK: - Métodos para conformar com os delegates
extension LoginViewModel: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            self.state = .loading
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            // TODO: Ver pq nao vem o displayName
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let user = authResult?.user {
                    print("Nice! You're now signed in as \(user.uid), email: \(user.email ?? "unkown")")
                    self.getAppleUserWithID(user: user)
                }

                if let error = error {
                    print(error.localizedDescription)
                }
                self.state = .idle
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}

// MARK: - Métodos privados de encriptação
extension LoginViewModel {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
