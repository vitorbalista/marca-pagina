import Foundation

protocol BookProtocol: Identifiable {
    func getBookTitle() -> String
    func getBookSubtitle() -> String?
    func getNumberOfPages() -> Int
    func getAuthors() -> [String]
    func getCategories() -> [String]?
    func getBookInfo() -> BookInfo
    func getImageLink() -> URL?
    func getBookGoogleId() -> String?
    func getDescription() -> String
    func getPublisher() -> String
    func getLanguage() -> String
    func getISBN() -> [BookIdentifiers]?
    func getFavorite() -> Bool?
    func getStatus() -> Status?
    func getPublishedDate() -> String
}
