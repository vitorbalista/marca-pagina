import Foundation
import SwiftUI

struct SingleRatingHeader: View {
    let name: String
    let date: String
    let rating: Int
    let imageRadius: CGFloat

    var body: some View {
        HStack(spacing: 17) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: imageRadius, height: imageRadius)
                .clipShape(Circle())
                .foregroundColor(.black)

            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(date)
                    .font(.footnote)
            }

            Spacer()

            StarsGrade(score: rating)
        }
        .padding([.leading, .trailing, .top])
    }
}
