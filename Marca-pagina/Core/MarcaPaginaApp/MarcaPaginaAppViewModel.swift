import FirebaseAuth
import SwiftUI
import Combine

final class MarcaPaginaAppViewModel: ObservableObject, ListenToUser {
    @Published var onLogin: Bool = false
    @Published var medal: [Medal]?
    @Published var showMedal = false

    private var currentUser: User?
    private(set) var discoverList: [DiscoverListModel] = []

    var bag = Set<AnyCancellable>()

    init() {
        loadUserData()
        listenUserData()
    }

    func loadUserData() {
        let loaded: UserData? = LocalFileManager
            .shared
            .load(fileName: LocalPath.fileName.rawValue,
                  folderName: LocalPath.folderName.rawValue)

        guard let loaded else { return }

        LocalFileManager.shared.updateUser(to: loaded)
    }

    func refreshData() {
        updateMedal()
        shouldAskForLogin()
    }

    func shouldAskForLogin() {
        let savedBooks = LocalFileManager.shared.userData.books.list

        if (savedBooks.count == 1) && (currentUser == nil) {
            listenToAuthState()
        }
    }

    func shouldListenToAuthState() {
        let savedBooks = LocalFileManager.shared.userData.books.list

        if savedBooks.count > 1 {
            listenToAuthState()
        }
    }

    func loadDiscoverList() {
        Task {
            self.discoverList = await FirestoreManager().getData(from: "DiscoverList")
        }
    }

    private func listenToAuthState() {

        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }

            self.onLogin = true

            if let user {
                print("Estou conectado como \(user.uid)")
                self.currentUser = user
                self.getUserDataFromBackEnd(id: user.uid)
                self.onLogin = false
            }
        }
    }

    private func getUserDataFromBackEnd(id: String) {
        let fireStoreManager = FirestoreManager()
        Task {
            if let userData: UserData = await fireStoreManager.getData(from: "UserData", documentID: id) {
                LocalFileManager.shared.updateUser(to: userData)
            }
        }
    }

}
