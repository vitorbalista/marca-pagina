import SwiftUI

struct CoordinatorContentView: View {

    @ObservedObject var object: CoordinatorContentObject
    
    init(object: CoordinatorContentObject) {
        self.object = object
        let appearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $object.tab) {
            CoordinatorLibraryView(object: object.coordinatorLibrary)
                .tabItem {
                    if object.tab == .library {
                        Image(systemName: Constants.bookTabImageFill)
                    } else {
                        Image(systemName: Constants.bookTabImage)
                            .environment(\.symbolVariants, .none)
                    }
                    Text("Biblioteca")
                }
                .tag(ContentTab.library)

            CoordinatorSearchView(object: object.coordinatorSearch)
                .tabItem {
                    Label("Busca", systemImage: Constants.searchTabImage)
                }
                .tag(ContentTab.search)

            CoordinatorChallengeView(object: object.coordinatorChallenge)
                .tabItem {
                    if object.tab == .challenge {
                        Image(Constants.achievementsTabImageFill)
                    } else {
                        Image(Constants.achievementsTabImage)
                    }
                    Text("Conquistas")
                }
                .tag(ContentTab.challenge)

            CoordinatorProfileView(object: object.coordinatorProfile)
                .tabItem {
                    if object.tab == .profile {
                        Image(systemName: Constants.profileTabImage)
                    } else {
                        Image(systemName: Constants.profileTabImageFill)
                            .environment(\.symbolVariants, .none)
                    }
                    Text("Perfil")
                }
                .tag(ContentTab.profile)
        }
    }

    enum Constants {
        static let achievementsTabImage = "achievements"
        static let achievementsTabImageFill = "achievements-fill"
        static let bookTabImage = "books.vertical"
        static let bookTabImageFill = "books.vertical.fill"
        static let searchTabImage = "magnifyingglass"
        static let profileTabImage = "person"
        static let profileTabImageFill = "person.fill"

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorContentView(object: CoordinatorContentObject())
    }
}
