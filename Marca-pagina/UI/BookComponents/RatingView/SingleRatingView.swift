import Foundation
import SwiftUI

struct SingleRatingView: View {
    let name: String
    let date: String
    let rating: Int
    let comment: String

    var body: some View {
        SingleRatingHeader(name: name, date: date, rating: rating, imageRadius: 40)
        SingleRatingBody(comment: comment, imageRadius: 40)
    }
}
