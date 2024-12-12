import SwiftUI

struct ChallengeView: View {

    enum Constants {
        static let navigationTitle = "Conquistas"
        static let challengesMarcaPagina = "Desafios"
        static let specialChallenges = "Especiais"
        static let momentChallenges = "Desafios do Momento"
    }

    @ObservedObject var viewModel: ChallengeViewModel

    var body: some View {
        ZStack {
            if viewModel.challenges.isEmpty {
                ProgressView()
                    .task {
                        await viewModel.getChallenges()
                    }
            } else {
                ScrollView {
                    VStack {
                        HeaderViewWithButton(text: Constants.challengesMarcaPagina) {
                            viewModel.goToAllChallengesView(listType: .marcaPagina)
                        }
                        .padding(.horizontal, 16)

                        ChallengesList(
                            listTitle: "",
                            challenges: viewModel.challenges,
                            mode: .horizontal,
                            cellType: .new
                        )
                        .padding(.leading, 16)
                        .padding(.bottom, 16)

                        if !viewModel.specialChallenges.isEmpty {
                            HeaderView(text: Constants.specialChallenges, fontSize: 17)
                                .padding(.horizontal, 24)

                            ChallengesList(
                                listTitle: "",
                                challenges: viewModel.specialChallenges,
                                mode: .horizontal,
                                cellType: .new)
                            .padding(.leading, 16)
                            .padding(.bottom, 16)
                        }

                        if !viewModel.medals.isEmpty {
                            MedalListCard(medals: Array(viewModel.medals.prefix(3))) {
                                viewModel.goToAllMedalsView()
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        }

                        if !viewModel.momentChallenges.isEmpty {
                            HeaderViewWithButton(text: Constants.momentChallenges) {
                                viewModel.goToMyChallengesView()
                            }
                            .padding(.horizontal, 16)

                            ChallengesList(
                                listTitle: "",
                                challenges: viewModel.momentChallenges,
                                mode: .horizontal,
                                cellType: .progress
                            )
                            .padding(.leading, 16)
                        }
                    }
                    .padding(.top, 24)
                }
            }
        }
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(
            viewModel: ChallengeViewModel(coordinator: CoordinatorChallengeObject())
        )
    }
}
