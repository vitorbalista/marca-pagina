import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

struct DiscoverListModel: Codable, Hashable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var imageLight: String
    var imageDark: String 
    var imageDescription: String
    var booksURL: [String]
    var backgroundImageLight: String
    var backgroundImageDark: String
    var medal: Medal
}
