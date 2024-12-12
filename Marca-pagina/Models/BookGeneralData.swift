import Foundation

struct BookGeneralData: Codable {
    let bookID: String
    var comments: [Comment]
    var rating: Rating
}
