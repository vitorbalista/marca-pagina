import SwiftUI

struct ChallengesList: View {

    let listTitle: String
    let challenges: [Challenge]
    let mode: Axis.Set
    let cellType: CellType

    var body: some View {
        ScrollView(mode, showsIndicators: false) {
            if mode == .horizontal {
                LazyHStack(spacing: 16) {
                    ForEach(challenges.count > 5 ? Array(challenges[0...4]) : challenges, id: \.title) { challenge in
                        ChallengesCell(
                            challenge: challenge,
                            size: CGSize(width: 250, height: 117),
                            expanded: false,
                            cellType: cellType
                        )
                        .padding(.vertical, 5)
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isButton)
                    }
                    .padding(.vertical, 16)
                }
                .padding(.leading, 8)
                .padding(.trailing, 4)
                .frame(height: 127)
            } else {
                LazyVStack(spacing: 16) {
                    HStack {
                        Text(self.listTitle)
                            .style(.bold, size: 20)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    ForEach(challenges, id: \.title) { challenge in
                        ChallengesCell(
                            challenge: challenge,
                            size: getVerticalCellSize(),
                            expanded: true,
                            cellType: cellType
                        )
                        .padding(.vertical, 2)
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isButton)
                    }
                }
                .padding(.bottom, 16)
            }
        }
    }

    private func getVerticalCellSize() -> CGSize {
        let width = UIScreen.main.bounds.width - 50
        let height: CGFloat = 132
        let size = CGSize(width: width, height: height)
        return size
    }
}

struct ChallengesList_Previews: PreviewProvider {
    static let challenges = [
        Challenge(
            description: "Livro dos anos 80",
            image: "",
            title: "Livro dos anos 80",
            imageDescription: nil
        )
    ]
    static let height: CGFloat = 137
    static var previews: some View {
        ChallengesList(
            listTitle: "Desafios",
            challenges: challenges,
            mode: .horizontal,
            cellType: .new
        )
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
