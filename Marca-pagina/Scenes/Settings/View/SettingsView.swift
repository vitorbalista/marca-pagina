import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationFormRow(text: "Editar Perfil",
                                      navigation: viewModel.openEditProfile)
                    
                    TextFieldFormRow()
                    
                    NavigationFormRow(text: "Alterar senha",
                                      navigation: viewModel.openChangePassword)
                }
                
                Section {
                    Toggle(isOn: $viewModel.showReadingGoal) {
                        Text("Exibir meta de leitura")
                            .style(.regular, size: 17)
                    }
                    
                    Toggle(isOn: $viewModel.showPagesReadChart) {
                        Text("Exibir gráfico de páginas lidas")
                            .style(.regular, size: 17)
                    }
                }
                
                Section {
                    Toggle(isOn: $viewModel.allowNotifications) {
                        Text("Habilitar notificações")
                            .style(.regular, size: 17)
                    }
                    
                    Toggle(isOn: $viewModel.activateDarkMode) {
                        Text("Modo escuro")
                            .style(.regular, size: 17)
                    }
                    
                    Toggle(isOn: $viewModel.useDeviceSettings) {
                        Text("Utilizar configurações do aparelho")
                            .style(.regular, size: 17)
                    }
                }
                
                Section {
                    NavigationFormRow(text: "Central de ajuda",
                                      navigation: viewModel.openHelpCenter)
                }
                
                Section {
                    Button {
                        UserUpdaterService.logOut()
                    } label: {
                        Text("Sair")
                            .foregroundColor(.red)
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Configurações")
                        .style(.bold, size: 17)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Salvar")
                        .style(.regular, size: 17)
                        .foregroundColor(ColorAsset.pink.primary)
                }
            })
        }
    }
    
    var cancelButton: some View {
        Button {
            viewModel.closeSetting()
        } label: {
            Text("Cancelar")
                .foregroundColor(ColorAsset.pink.primary)
        }
    }
}

struct NavigationFormRow: View {
    let text: String
    let navigation: () -> Void
    
    var body: some View {
        HStack {
            Text(text)
                .style(.regular, size: 17)
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}

struct TextFieldFormRow: View {
    @State var text = ""
    
    var body: some View {
        HStack {
            Text("Alterar e-mail")
                .style(.regular, size: 17)
            
            // TODO: Get user email
            // TODO: Deal with Apple user who doesn't share email
            // TODO: Deal with invalid email format
            TextField("Digite seu e-mail", text: $text)
                .style(.regular, size: 15)
                .multilineTextAlignment(.trailing)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundColor(Color(uiColor: UIColor.systemGray))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(CoordinatorProfileObject()))
    }
}
