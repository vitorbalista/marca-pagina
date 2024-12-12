import SwiftUI

struct AchievementsCollectionView: View {

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let cards: [String]
    let height: CGFloat

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(cards, id: \.self) { card in
                    AchievementsView(imageName: card)
                }
            }
            .padding()
        }
    }
}

struct AchievementsCollectionView_Previews: PreviewProvider {
    static let height: CGFloat = 102
    static let cards: [String] = [
        "Medalha Início da Jornada", "5 livros", "10 livros", "15 livros", "20 livros", "30 livros",
        "40 livros", "50 livros"
    ]
    static var previews: some View {
        AchievementsCollectionView(cards: cards,
                                   height: height)
    }
}
