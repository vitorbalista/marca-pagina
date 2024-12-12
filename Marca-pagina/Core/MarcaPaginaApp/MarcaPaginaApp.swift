import SwiftUI

@main
struct MarcaPaginaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject private var viewModel = MarcaPaginaAppViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                Group {
                    if viewModel.onLogin {
                        CoordinatorLoginView(object: CoordinatorLoginObject())
                    } else {
                        CoordinatorContentView(object: CoordinatorContentObject())
                    }
                }
                if let medal = viewModel.medal?.first,
                   viewModel.showMedal {
                    MedalPopover(medal: medal) {
                        viewModel.medalPopoverAction()
                    }
                }
            }
            .onAppear {
                viewModel.shouldListenToAuthState()
                viewModel.loadDiscoverList()
            }
            .animation(.easeInOut, value: UUID())
        }
    }
}
