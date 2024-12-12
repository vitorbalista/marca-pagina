import SwiftUI

struct AllChallengesView: View {

    enum Constants {
        static let navigationTitle = "Desafios"
    }

    let challenges: [Challenge]
    let specialChallenges: [Challenge]
    let listTitle: String

    var body: some View {
        ScrollView {
            ChallengesList(listTitle: "Desafios Marca-Página",
                           challenges: challenges,
                           mode: .vertical,
                           cellType: .new)

            ChallengesList(listTitle: "Desafios Especiais",
                           challenges: specialChallenges,
                           mode: .vertical,
                           cellType: .new)
        }
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AllChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        AllChallengesView(challenges: [],
                          specialChallenges: [],
                          listTitle: "")
    }
}
