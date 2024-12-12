import Foundation
import SwiftUI

struct GenreView: View {

    let genres: [Genre]
    let size: CGSize
    let headerHeight: CGFloat

    var body: some View {
        VStack(spacing: 22) {
            HeaderView(text: "Gênero")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 32) {
                    ForEach(genres, id: \.self) { gender in
                        HStack(spacing: 12) {
                            ZStack {
                                // Isso vai mudar quando tivermos as imagens nos assets
                                Rectangle()
                                    .frame(width: size.width,
                                           height: size.height)
                                    .cornerRadius(5)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 6)

                                gender.image
                                    .resizable()
                                    .frame(width: size.width,
                                       height: size.height)
                                    .padding(.leading, 6)
                            }

                            Text(gender.rawValue)
                                .style(.regular, size: 20)
                        }
                        .padding(.trailing, 20)
                    }
                }
            }
        }
    }
}

struct GenreView_Previews: PreviewProvider {

    static let size = CGSize(width: 31, height: 31)
    static let genders: [Genre] = [.infantil, .acaoAventura, .crime, .romance]
    static let headerHeight = CGFloat(24)

    static var previews: some View {
        GenreView(genres: genders, size: size, headerHeight: headerHeight)
    }
}
