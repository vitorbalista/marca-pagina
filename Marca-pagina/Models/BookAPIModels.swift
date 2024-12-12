import Foundation

struct GoogleAPIBook: Codable {
    let items: [BookInfo]
    let totalItems: Int
}

struct BookInfo: Codable, Equatable, Identifiable, BookProtocol {
    let id: String
    let volumeInfo: BookDetails
    var selfLink: String = ""

    func getFavorite() -> Bool? {
        return nil
    }

    func getStatus() -> Status? {
        return nil
    }

    static func == (lhs: BookInfo, rhs: BookInfo) -> Bool {
        lhs.id == rhs.id
    }

    func getImageLink() -> URL? {
        guard let link = self.volumeInfo.imageLinks?.thumbnail else { return nil }
        var component = URLComponents(string: link)
        component?.scheme = "https"
        let safeLink = component?.url
        return safeLink
    }

    func getBookGoogleId() -> String? {
        return self.id
    }
    func getDescription() -> String {
        if let description = self.volumeInfo.description?.htmlToString {
            return description
        } else {
            return "Sem descrição"
        }
    }

    func getPublisher() -> String {
        if let publisher = volumeInfo.publisher {
            return publisher
        } else {
            return "Erro ao buscar editora"
        }
    }

    func getLanguage() -> String {
        return self.volumeInfo.language
    }

    func getISBN() -> [BookIdentifiers]? {
        return self.volumeInfo.industryIdentifiers
    }

    func getBookTitle() -> String {
        return self.volumeInfo.title
    }

    func getBookSubtitle() -> String? {
        return ""
    }

    func getNumberOfPages() -> Int {
        if let pageCount = self.volumeInfo.pageCount {
            return pageCount
        } else {
            return 0
        }
    }

    func getAuthors() -> [String] {
        return self.volumeInfo.authors
    }

    func getCategories() -> [String]? {
        return self.volumeInfo.categories
    }

    func getBookInfo() -> BookInfo {
        return self
    }

    func getPublishedDate() -> String {
        if let publishedDate = self.volumeInfo.publishedDate {
            return publishedDate
        } else {
            return "Sem data"
        }
    }

    func getNumberOfHours() -> Int? {
        return self.volumeInfo.totalHours
    }
}

final class BookDetails: Codable {
    let title: String
    let authors: [String]
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let industryIdentifiers: [BookIdentifiers]?
    private(set) var pageCount: Int?
    let imageLinks: ImageLinks?
    let language: String
    let categories: [String]?

    // MARK: Variables in addition to API response
    private(set) var totalHours: Int?

    enum CodingKeys: CodingKey {
        case title
        case authors
        case publisher
        case publishedDate
        case description
        case industryIdentifiers
        case pageCount
        case imageLinks
        case language
        case categories
        case totalHours
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        if let authors = try container.decodeIfPresent([String].self, forKey: .authors) {
            self.authors = authors
        } else {
            self.authors = []
        }
        self.publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
        self.publishedDate = try container.decodeIfPresent(String.self, forKey: .publishedDate)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.industryIdentifiers = try container.decodeIfPresent([BookIdentifiers].self, forKey: .industryIdentifiers)
        self.pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
        self.imageLinks = try container.decodeIfPresent(ImageLinks.self, forKey: .imageLinks)
        self.language = try container.decode(String.self, forKey: .language)
        self.categories = try container.decodeIfPresent([String].self, forKey: .categories)
        self.totalHours = try container.decodeIfPresent(Int.self, forKey: .totalHours)
    }

    init(title: String, language: String) {
        self.title = title
        self.language = language
        self.authors = [""]
        self.publisher = nil
        self.publishedDate = nil
        self.description = nil
        self.industryIdentifiers = nil
        self.pageCount = nil
        self.imageLinks = nil
        self.categories = nil

        self.totalHours = nil
    }

    init(title: String,
         authors: [String],
         publisher: String?,
         publishedDate: String?,
         description: String?,
         industryIdentifiers: [BookIdentifiers]?,
         pageCount: Int?,
         imageLinks: ImageLinks?,
         language: String,
         categories: [String]?) {
        self.title = title
        self.authors = authors
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.description = description
        self.industryIdentifiers = industryIdentifiers
        self.pageCount = pageCount
        self.imageLinks = imageLinks
        self.language = language
        self.categories = categories

        self.totalHours = nil
    }

    func updateTotalNumber(for option: ProgressOption, to number: Int?) {
        switch option {
        case .pages:
            pageCount = number
        case .hours:
            totalHours = number
        default:
            return
        }
    }
}

struct BookIdentifiers: Codable {
    let type: String
    let identifier: String

}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

private extension String {
    var htmlToString: String {
        self
            .replacingOccurrences(of: "</p>", with: "\n")
            .replacingOccurrences(
                of: "<[^>]+>",
                with: "",
                options: .regularExpression,
                range: nil)
            .replacingOccurrences(of: "&quot;", with: "\"")
    }
}
