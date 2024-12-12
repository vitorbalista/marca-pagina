import SwiftUI

struct AchievementsView: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct ConquistasView_Previews: PreviewProvider {
    static let imageHeight: CGFloat = 50
    static let imageName: String = "BrasilImage"
    static let size = CGSize(width: 102,
                             height: 102)
    static var previews: some View {
        AchievementsView(imageName: imageName)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
