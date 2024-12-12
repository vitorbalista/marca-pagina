import Foundation

struct UserData: Codable {
    var photo: String
    var name: String
    var books: SavedBooks
    var medals: [Medal]
    var annualGoal: AnnualGoal
    let userID: String
    var challenges: [Challenge]
}

struct Medal: Codable, Hashable {
    let title: String
    let image: String?
    let medalType: MedalType
}

struct AnnualGoal: Codable {
    var value: Int
    var shouldShowAnnualGoal: Bool
}

struct Challenge: Codable {
    let description: String
    let image: String
    let title: String
    let imageDescription: String?
}

enum MedalType: String, CaseIterable, Codable {
    case monthly = "Mensais"
    case diversity = "Diversidade"
    case genres = "Gêneros"
    case goal = "Metas"
}
