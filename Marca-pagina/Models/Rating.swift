import Foundation

struct Rating: Codable {
    var value: Float
    var totalVotes: Int
    var usersRatings: [PersonalRating]
}

struct PersonalRating: Codable {
    var value: Float
    var userId: String
}
