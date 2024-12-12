import Foundation

class CoordinatorChallengeObject: ObservableObject {

    @Published var challengeViewModel: ChallengeViewModel!
    @Published var medals: [Medal]?
    @Published var challenges: [Challenge]?
    var allChallengesTitle = ""

    init() {
        self.challengeViewModel = ChallengeViewModel(coordinator: self)
    }

    func open(_ challenges: [Challenge], listType: ChallengeListType) {
        self.allChallengesTitle = listType.rawValue
        self.challenges = challenges
    }

    func open(medals: [Medal]) {
        self.medals = medals
    }

    func open(_ challenges: [Challenge]) {
        self.challenges = challenges
    }
}
