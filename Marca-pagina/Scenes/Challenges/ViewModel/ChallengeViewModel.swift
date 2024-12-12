import Combine
import UIKit

enum ChallengeListType: String {
    case marcaPagina = "Desafios Marca-Página"
    case specialChallenges = "Desafios Especiais"
}

class ChallengeViewModel: ObservableObject, ListenToUser {

    @Published var specialChallenges: [Challenge] = []
    @Published var momentChallenges: [Challenge] = []

    // TODO: Get medals from user
    @Published var medals: [Medal] = [ ]

    @Published var challenges: [Challenge] = []

    var bag = Set<AnyCancellable>()

    private unowned let coordinator: CoordinatorChallengeObject

    init(coordinator: CoordinatorChallengeObject) {
        self.coordinator = coordinator

        loadMyChallenges()
        loadMedals()
        listenUserData()
    }

    func goToAllChallengesView(listType: ChallengeListType) {
        switch listType {
        case .marcaPagina:
            coordinator.open(challenges, listType: listType)
        case .specialChallenges:
            coordinator.open(specialChallenges, listType: listType)
        }
    }

    func getChallenges() async {
        let firebaseManager = FirestoreManager()
        let challenges: [Challenge] = await firebaseManager.getData(from: "PatternChallengeList")
        let specialChallenges: [Challenge] = await firebaseManager.getData(from: "SpecialChallengeList")
        DispatchQueue.main.async {
            self.challenges = challenges
            self.specialChallenges = specialChallenges
            self.momentChallenges = challenges
        }
    }

    func goToAllMedalsView() {
        coordinator.open(medals: medals)
    }

    func goToMyChallengesView() {
        coordinator.open(momentChallenges)
    }

    func refreshData() {
        loadMyChallenges()
        loadMedals()
    }

    private func loadMyChallenges() {
        self.momentChallenges = LocalFileManager.shared.userData.challenges
    }
    private func loadMedals() {
        self.medals = LocalFileManager.shared.userData.medals
    }
}
