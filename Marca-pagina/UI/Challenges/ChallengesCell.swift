import SwiftUI

enum CellType {
    case new
    case progress
}

struct ChallengesCell: View {

    let challenge: Challenge
    let size: CGSize
    let expanded: Bool
    let cellType: CellType

    @Environment(\.colorScheme) var colorScheme
    @State private var presentAlert = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.init(uiColor: UIColor.tertiarySystemBackground))
                .shadow(color: .black.opacity(0.2),
                        radius: 4)
                .frame(width: size.width, height: size.height)

            if let url = self.getImageURL() {
                CacheAsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    default:
                        HStack {
                            VStack(alignment: .leading, spacing: 9) {
                                Text(challenge.title)
                                    .style(.bold, size: expanded ? 20 : 18)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(2)
                                    .padding(.top, 24)

                                Text(challenge.description)
                                    .style(.regular, size: expanded ? 14 : 12)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(4)

                                Spacer()
                            }
                            .padding(.leading, 12)
                            .layoutPriority(2)
                            .frame(width: self.getTextWidth(), alignment: .leading)

                            if case .success(let image) = phase {
                                image
                                    .resizable()
                                    .frame(width: expanded ? 100 : 83, height: expanded ? 100 : 83)
                                    .padding(.trailing, 12)
                            }
                            if case .failure = phase {
                                Image(systemName: "cloud")
                                    .resizable()
                                    .frame(width: 83, height: 83)
                                    .padding(.trailing, 12)
                            }
                        }
                    }
                }
            }
        }
        .frame(width: size.width,
               height: size.height)
        .onTapGesture {
            presentAlert = true
        }
        .alert(challenge.title, isPresented: $presentAlert) {
            Button(role: .cancel) {

            } label: {
                Text("Cancelar")
            }

            switch cellType {
            case .new:
                Button(role: .destructive) {

                    LocalFileManager.shared.addChallenge(challenge: challenge)
                } label: {
                    Text("Participar")
                }
            case .progress:
                Button(role: .destructive) {

                    LocalFileManager.shared.deleteChallenge(challenge: challenge)
                } label: {
                    Text("Excluir")
                }
            }
        } message: {
            Text(challenge.description)
        }
    }

    private func getTextWidth() -> CGFloat {
        return size.width-24-8-83
    }

    private func getImageURL() -> URL? {
        if self.colorScheme == .dark {
            let newURLString = self.challenge.image.replacingOccurrences(of: "Light", with: "Dark")
            return URL(string: newURLString)
        }
        return URL(string: self.challenge.image)
    }
}

struct ChallengesCell_Previews: PreviewProvider {

    static let achievementText: String = "5 Livros em 2022"
    static let achievementImage: String = "Jornada"
    static let challenge = Challenge(description: achievementText,
                                     image: achievementImage,
                                     title: "Challenge",
                                     imageDescription: "image description")

    static let size = CGSize(width: 199, height: 101)
    static let imageSize = CGSize(width: 41, height: 41)

    static var previews: some View {
        ChallengesCell(challenge: challenge,
                       size: size,
                       expanded: false,
                       cellType: .new)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
