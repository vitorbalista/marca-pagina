import SwiftUI
import Combine

struct ReadingProgressView: View {
    @ObservedObject var viewModel: ReadingProgressViewModel

    init(viewModel: ReadingProgressViewModel) {
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .font: UIFont(name: "Atkinson Hyperlegible Bold", size: 13) ?? UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.label
            ], for: .selected)

        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .font: UIFont(name: "Atkinson Hyperlegible Regular", size: 13) ?? UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.label
            ], for: .normal)

        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                HStack {
                    Text("Quanto você já leu?")
                        .style(.bold, size: 30)
                }
                .padding(.top, 32)

                Text(viewModel.book?.bookInfo.getBookTitle() ?? "")
                    .style(.regular, size: 17)

                Picker("", selection: $viewModel.selectedProgressOption) {
                    ForEach(viewModel.progressOptions, id: \.self) {
                        Text($0.rawValue)
                            .foregroundColor(.blue)
                    }
                }
                .pickerStyle(.segmented)

                ProgressTextField(selectedOption: $viewModel.selectedProgressOption,
                                  number: $viewModel.progressNumber,
                                  sufix: "lidas")
                .onReceive(Just(viewModel.progressNumber)) {_ in
                    viewModel.filterText(viewModel.progressNumber,
                                         type: .progress)
                }

                Text("de")
                    .style(.regular, size: 22)

                if viewModel.selectedProgressOption == .percent {
                    HStack(alignment: .bottom) {
                        Text("100")
                            .style(.bold, size: 38)
                            .foregroundColor(.accentColor)
                        Text("%")
                            .style(.bold, size: 23)
                            .foregroundColor(.accentColor)
                            .padding(.bottom, 5)
                    }
                } else {
                    ProgressTextField(selectedOption: $viewModel.selectedProgressOption,
                                      number: $viewModel.totalNumber,
                                      sufix: "totais")
                    .onReceive(Just(viewModel.progressNumber)) {_ in
                        viewModel.filterText(viewModel.totalNumber,
                                             type: .total)
                    }
                    .onAppear {
                        viewModel.totalNumber = viewModel.getNumberOfPages()
                    }
                }

                Text("Última atualização 10/01/2022")
                    .style(.regular, size: 15)
                    .foregroundColor(Color(uiColor: UIColor.systemGray))

                if viewModel.isProgressGreaterThanTotal() {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 15))
                            .padding(.bottom, 5)
                        Text("O valor não pode ser maior que o total")
                            .style(.regular, size: 15)
                    }
                    .foregroundColor(ColorAsset.red.primary)
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .navigationTitle("Progresso")
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
            viewModel.saveBookProgress()
        } label: {
            Text("Salvar")
                .foregroundColor(.accentColor)
        }
    }
}

struct ProgressTextField: View {
    @Binding var selectedOption: ProgressOption
    @Binding var number: String

    @State var placeholder: String = ""
    var sufix: String

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
            .onChange(of: selectedOption) { newValue in
                placeholder = (newValue == .percent) ? "Valor" : "\(newValue.rawValue) \(sufix)"
            }
            .onAppear {
                placeholder = "\(selectedOption.rawValue) \(sufix)"
            }
    }
}

struct ReadingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingProgressView(viewModel: .init(coordinator: .init()))
    }
}
