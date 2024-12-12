import Foundation
import FirebaseAuth

extension MarcaPaginaAppViewModel {

    func updateMedal() {
        guard Auth.auth().currentUser != nil else { return }

        let booksList = LocalFileManager
            .shared
            .userData
            .books
            .list
            .filter({ $0.status == .read })

        var medalsToWin = [Medal]()
        let firstMedal = Medal(title: "Primeira Medalha", image: "PrimeiraMedalha", medalType: .goal)

        if !LocalFileManager
            .shared
            .userData
            .medals
            .contains(where: { $0.title == firstMedal.title }) && booksList.count > 0 {

            medalsToWin.append(firstMedal)
        }

        for list in discoverList {
            let books = list.booksURL.filter { selectedBook in
                return booksList.contains(where: { $0.bookInfo.selfLink == selectedBook })
            }

            if !books.isEmpty {
                let rewardMedal = list.medal
                if !LocalFileManager
                    .shared
                    .userData
                    .medals
                    .contains(where: { $0.title == rewardMedal.title }) {

                    medalsToWin.append(rewardMedal)
                }
            }
        }

        if !medalsToWin.isEmpty {
            self.medal = medalsToWin
            LocalFileManager.shared.addMedals(medalsToWin)
            LocalFileManager.shared.updateUser(to: LocalFileManager.shared.userData)

            let firebaseManager = FirestoreManager()
            firebaseManager.setData(userData: LocalFileManager.shared.userData)

            self.showMedal = true
        }
    }

    func medalPopoverAction() {
        showMedal = false
        medal?.remove(at: 0)
        if medal?.isEmpty == true {
            medal = nil
        } else {
            showMedal = true
        }
    }
}
