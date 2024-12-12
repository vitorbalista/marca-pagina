import SwiftUI
import Combine

// swiftlint:disable line_length

struct AnnualGoalUpdateView: View {
    @ObservedObject var viewModel: AnnualGoalUpdateViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 32) {
                Text("Você quer colocar uma meta anual para suas leituras?")
                    .style(.bold, size: 17)
                    .padding(.top, 16)

                Text("Você pode editar esse valor sempre que quiser e essa meta será visível apenas para você. O maior objetivo é que você leia o quanto quiser!")
                    .style(.regular, size: 16)

                AnnualGoalTextField(number: $viewModel.annualGoalValue)
                    .padding(.bottom, 10)

                Text("Não quer aderir à meta anual?")
                    .style(.bold, size: 17)

                Text("Não tem problema! Você pode retirar a meta anual da Biblioteca e não preencher a meta. Pronto! Você não estará participando.")
                    .style(.regular, size: 15)
                    .padding(.bottom, 10)

                HStack(alignment: .top) {
                    Button {
                        viewModel.shouldShowAnnualGoal.toggle()
                    } label: {
                        roundedRectangle
                    }

                    VStack {
                        Text("Não quero que a meta de leitura anual apareça na Biblioteca.")
                            .style(.regular, size: 16)
                            .padding(.bottom, 4)

                        Text("Caso você mude de ideia é possível editar essa opção no menu de configurações no seu perfil.")
                            .style(.regular, size: 13)
                            .foregroundColor(Color(uiColor: UIColor.systemGray))
                            .padding(.horizontal, 16)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 32)
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .navigationTitle("Meta anual")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var cancelButton: some View {
        Button {
            viewModel.dismiss()
        } label: {
            Text("Cancelar")
                .foregroundColor(.accentColor)
        }
    }

    var saveButton: some View {
        Button {
            viewModel.saveAnnualGoal()
        } label: {
            Text("Salvar")
                .foregroundColor(.accentColor)
        }
    }

    var roundedRectangle: some View {
        Group {
            if viewModel.shouldShowAnnualGoal {
                RoundedRectangle(cornerRadius: 4, style: .circular)
                    .stroke(Color.accentColor, lineWidth: 0.8)
                    .frame(width: 16, height: 16)
            } else {
                RoundedRectangle(cornerRadius: 4, style: .circular)
                    .frame(width: 16, height: 16)
            }
        }
    }
}

struct AnnualGoalTextField: View {
    @Binding var number: String

    @State var placeholder: String = "Quantidade"

    var body: some View {
        TextField(placeholder, text: $number)
            .style(.regular, size: 17)
            .frame(width: 177, height: 44)
            .padding(.horizontal, 16)
            .background(Color(uiColor: UIColor.systemBackground))
            .cornerRadius(16)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .lineLimit(1)
    }
}

struct AnnualGoalUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        AnnualGoalUpdateView(viewModel: .init(coordinator: .init()))
    }
}
