import SwiftUI

struct CoordinatorProfileView: View {
    @ObservedObject var object: CoordinatorProfileObject

    var body: some View {
        NavigationView {
            ProfileView(viewModel: object.profileViewModel)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            object.openSettings()
                        } label: {
                            Image(systemName: "gearshape.2.fill")
                                .foregroundColor(ColorAsset.pink.primary)
                        }
                    }
                }
                .sheet(isPresented: $object.showGoalView) { GoalView(viewModel: object.profileViewModel) }
                .sheet(item: $object.settingsViewModel) {
                    SettingsView(viewModel: $0)
                }
        }
    }
}
