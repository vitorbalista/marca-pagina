import SwiftUI

struct DiscoverView: View {
    let title: String
    let description: String
    let imageURL: String
    let imageDescription: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.init(uiColor: UIColor.tertiarySystemBackground))
                .shadow(color: .black.opacity(0.2),
                        radius: 6, y: 4)
            if let url = URL(string: imageURL) {
                CacheAsyncImage(url: url, scale: 1.0, transaction: .init()) { phase in
                    HStack(spacing: 24) {
                        switch phase {
                        case .empty:
                            ProgressView()
                                .padding(.vertical, 72)

                        default:
                            VStack(alignment: .leading, spacing: 16) {
                                Text(title)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.top)
                                Text(description)
                                    .font(.footnote)
                                    .padding(.bottom)
                            }
                            .padding(.leading)

                            if case let .success(image) = phase {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .clipShape(Circle())
                                    .padding(.trailing)
                            } else if case .failure = phase {
                                Image("cloud")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .clipShape(Circle())
                                    .padding(.trailing)
                            }
                        }
                    }
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title). \(description). \(imageDescription)")
        .accessibilityAddTraits(.isButton)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static let title = "Livros de mistério e suspense"
    static let description = """
                     Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                     Sed malesuada efficitur lorem id consequat. Vestibulum
                     """
    static let imageURL = "https://conteudo.imguol.com.br/c/entretenimento/32/2018/01/18/maca-1516308281068_v2_4x3.jpg"

    static var previews: some View {
        DiscoverView(title: title,
                     description: description,
                     imageURL: imageURL,
                     imageDescription: "Image do Livro que vem do banco")
    }
}
