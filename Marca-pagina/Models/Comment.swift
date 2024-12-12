import Foundation

struct Comment: Codable {
    let commentId: UUID
    let userId: String
    var text: String
    var date: Date
}
