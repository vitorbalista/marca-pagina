import Foundation
import SwiftUI

final class SavedBook: Codable {
    let bookInfo: BookInfo
    let status: Status
    let coments: String
    let rating: Float
    let favorite: Bool

    let startDate: Date?
    let endDate: Date?
    private(set) var pagesRead: Int?
    private(set) var lastUpdateDate: Date?

    init(
        bookInfo: BookInfo,
        status: Status,
        coments: String, rating: Float,
        favorite: Bool,
        pagesRead: Int? = nil,
        startDate: Date? = nil,
        lastUpdateDate: Date? = nil,
        endDate: Date? = nil
    ) {
        self.bookInfo = bookInfo
        self.status = status
        self.coments = coments
        self.rating = rating
        self.favorite = favorite
        self.pagesRead = pagesRead
        self.startDate = startDate
        self.lastUpdateDate = lastUpdateDate
        self.endDate = endDate
    }

    func updatePagesRead(to value: Int?) {
        lastUpdateDate = .now
        pagesRead = value
    }
}

struct SavedBooks: Codable {
    var list: [SavedBook]
}

enum Status: String, Codable, CaseIterable {

    case want
    case inProgress
    case read

    var achievementText: String {
        switch self {
        case .want:
            return "Livros na lista de quero ler"
        case .read:
            return "Livros lidos"
        case .inProgress:
            return "Livros sendo lidos atualmente"
        }
    }

    var image: String {
        switch self {
        case .want:
            return "Livros Quero Ler"
        case .inProgress:
            return "Livros Estou Lendo"
        case .read:
            return "Livros Lidos"
        }
    }

    var foregroundColor: Color {
        switch self {
        case .want:
            return ColorAsset.pink.primary
        case .inProgress:
            return ColorAsset.blue.primary
        case .read:
            return ColorAsset.red.primary
        }
    }
}
