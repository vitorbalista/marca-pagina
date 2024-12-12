import SwiftUI
import Combine

struct GoalView: View {

    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Frequência")
                        .style(.regular, size: 18)

                    Spacer()

                    Picker(selection: $viewModel.selectedFrequency) {
                        ForEach(ProfileViewModel.SelectedFrequency.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    } label: {}
                        .pickerStyle(.menu)
                }

                HStack {
                    Text("Meta de páginas")
                        .style(.regular, size: 18)

                    Spacer()

                    VStack {
                        TextField("0", text: $viewModel.goal)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .onReceive(Just(viewModel.goal)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    viewModel.goal = filtered
                                }
                            }

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.green)
                    }
                    .frame(width: 96, alignment: .trailing)
                }

                HStack {
                    Toggle(isOn: .constant(false)) {
                        Text("Exibir lembre para leitura")
                            .style(.regular, size: 18)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Cancelar")
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Cancelar")
                                .style(.regular, size: 17)
                        }
                        .foregroundColor(ColorAsset.pink.primary)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("Alterar meta")
                        .style(.bold, size: 17)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.save()
                    } label: {
                        Text("Salvar")
                            .style(.regular, size: 17)
                            .foregroundColor(ColorAsset.pink.primary)
                    }
                }
            }
        }
    }
}

 struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(viewModel: ProfileViewModel(CoordinatorProfileObject()))
    }
 }
