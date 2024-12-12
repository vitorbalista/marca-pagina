import SwiftUI

struct CoordinatorChallengeView: View {
    @ObservedObject var object: CoordinatorChallengeObject

    var body: some View {
        NavigationView {
            ChallengeView(viewModel: object.challengeViewModel)
                .navigation(item: $object.medals) { AllMedalsView(medals: $0)}
                .navigation(item: $object.challenges) {
                    AllChallengesView(challenges: $0,
                                      specialChallenges: object.challengeViewModel.specialChallenges,
                                      listTitle: object.allChallengesTitle)
                    .padding(.top)
                }
        }
    }
}
