import SwiftUI

struct MedalListCard: View {
    let medals: [Medal]
    let navigation: () -> Void

    var body: some View {
        VStack {
            HeaderViewWithButton(text: "Medalhas",
                                 action: navigation)
            card
        }
    }

    var card: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.init(uiColor: UIColor.tertiarySystemBackground))
                .shadow(color: .black.opacity(0.2),
                        radius: 6, y: 4)

            HStack(spacing: 16) {
                ForEach(medals, id: \.self) { medal in
                    if let imageName = medal.image,
                       let image = UIImage(named: imageName) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 98, height: 98)
                            .clipShape(Circle())
                            .padding(.vertical, 16)
                            .accessibilityLabel(imageName)
                    }
                }
            }
        }
    }
}

 struct MedalListCard_Previews: PreviewProvider {
    static let medals: [Medal] = [
        Medal(title: "Medalha Início da Jornada", image: "author-icon", medalType: .goal),
        Medal(title: "5 livros", image: "author-icon", medalType: .goal),
        Medal(title: "10 livros", image: "author-icon", medalType: .goal)
    ]

    static let navigation = { }

    static var previews: some View {
        MedalListCard(medals: medals,
                      navigation: navigation)
    }
 }
