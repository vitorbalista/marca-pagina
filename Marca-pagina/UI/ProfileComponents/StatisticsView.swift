import SwiftUI

struct StatisticsView: View {

    let imageName: String
    let text: String
    let goal: Int
    let foregroundColor: Color
    let imageSize: CGSize

    var body: some View {
        HStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(foregroundColor)
                .frame(width: imageSize.width,
                       height: imageSize.height)
            Text(self.getGoalString(goal))
                .style(.bold, size: 40)
                .foregroundColor(foregroundColor)
            Text(text)
                .style(.regular, size: 17)
                .lineLimit(nil)
        }
    }

    private func getGoalString(_ goal: Int) -> String {
        if goal < 10 && goal > 0 {
            return "0\(goal)"
        }
        return "\(goal)"
    }
}

struct EstatisticasView_Previews: PreviewProvider {

    static let imageName: String = "bookmark"
    static let text: String = "Livros Favoritados"
    static let metaBatida: Int = 10000
    static let imageSize: CGSize = CGSize(width: 18,
                                            height: 18)

    static var previews: some View {
        StatisticsView(imageName: imageName,
                       text: text,
                       goal: metaBatida,
                       foregroundColor: .blue,
                       imageSize: imageSize)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
