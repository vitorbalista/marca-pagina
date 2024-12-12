import SwiftUI

struct CoordinatorLoginView: View {
    @ObservedObject var object: CoordinatorLoginObject

    var body: some View {
        NavigationView {
            LoginView(viewModel: LoginViewModel(coordinator: object))
                .navigation(item: $object.registerViewModel) {
                    RegisterView(viewModel: $0)
                }
                .navigation(item: $object.recoverViewModel) {
                    RecoverPasswordView(viewModel: $0)
                }
        }
    }
}
