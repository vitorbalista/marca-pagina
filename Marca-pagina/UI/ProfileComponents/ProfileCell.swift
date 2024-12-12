import SwiftUI

enum ProfilePosition {
    case vertical
    case horizontal
}

struct ProfileCell: View {

    let imageName: String
    let name: String
    let frameSize: CGSize
    let imageSize: CGSize
    let profilePosition: ProfilePosition

    init(imageName: String = "person",
         name: String,
         frameSize: CGSize,
         imageSize: CGSize,
         profilePosition: ProfilePosition) {
        self.imageName = imageName
        self.name = name
        self.frameSize = frameSize
        self.imageSize = imageSize
        self.profilePosition = profilePosition
    }

    var body: some View {
        switch profilePosition {
        case .horizontal:
                HStack(alignment: .center, spacing: 24) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize.height,
                           height: imageSize.height )
                    .clipShape(Circle())
                    .padding(.trailing, 3)
                Text(name)
                    .style(.bold, size: 22)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .frame(width: frameSize.width,
                   height: frameSize.height)
        case .vertical:
            VStack(spacing: 24) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize.width,
                           height: imageSize.height )
                    .background(.blue)
                    .clipShape(Circle())
                Text(name)
                    .style(.bold, size: 17)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: UIScreen.main.bounds.width,
                   height: frameSize.height)
        }
    }
}

struct ProfileCell_Previews: PreviewProvider {

    static let name = "Fernandinho O Leitor"
    static let frameSize = CGSize(width: 328, height: 136)
    static let imageSize = CGSize(width: 180, height: 74)

    static var previews: some View {
        ProfileCell(imageName: "user padrao",
                    name: name,
                    frameSize: frameSize,
                    imageSize: imageSize,
                    profilePosition: .horizontal)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
