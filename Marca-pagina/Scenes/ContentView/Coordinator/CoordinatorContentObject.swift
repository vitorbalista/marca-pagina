import Foundation

enum ContentTab {
    case library
    case search
    case challenge
    case profile
}

class CoordinatorContentObject: ObservableObject {
    @Published var tab = ContentTab.library
    @Published var coordinatorLibrary = CoordinatorLibraryObject()
    @Published var coordinatorSearch = CoordinatorSearchObject()
    @Published var coordinatorChallenge = CoordinatorChallengeObject()
    @Published var coordinatorProfile = CoordinatorProfileObject()
}
