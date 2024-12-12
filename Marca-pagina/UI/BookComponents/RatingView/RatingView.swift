import Foundation
import SwiftUI

struct RatingView: View {
    let name: String
    let date: String
    let rating: Int?
    let comment: String?

    var body: some View {
        VStack {
            HStack {
                HeaderView(text: "Avaliações")

                Button {
                    print("criar nova avaliacao")
                } label: {
                    HStack(alignment: VerticalAlignment.lastTextBaseline) {
                        Text("Nova Avaliação")
                            .style(.regular, size: 16)

                        Image(systemName: "square.and.pencil")
                    }
                }
            }

            if let rating = rating, let comment = comment {
                SingleRatingView(name: name,
                                 date: date,
                                 rating: rating,
                                 comment: comment)
            } else {
                VStack {
                    Image("empty-rating")
                    Text("Este livro ainda não foi avaliado")
                        .style(.bold, size: 17)
                }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(name: "Zeca", date: "02/02/2002", rating: 2, comment: "Muito bom")
    }
}
