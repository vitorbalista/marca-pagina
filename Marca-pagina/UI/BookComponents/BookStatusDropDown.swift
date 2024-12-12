import SwiftUI

struct BookStatusDropDown: View {

    @ObservedObject var bookInfoViewModel: BookInfoViewModel

    let text = ["Quero ler", "Estou lendo", "Já li", "Remover da lista"]

    @State var selectedStatus = "Adicionar à lista"

    var body: some View {
        VStack {
            Menu {
                Picker("Status", selection: $bookInfoViewModel.selectedStatus) {
                    ForEach(text, id: \.self) {
                        switch $0 {
                        case "Quero ler":
                            HStack {
                                Text("Quero ler")
                                    .style(.regular, size: 17)

                                Image(systemName: "star")
                            }
                        case "Estou lendo":
                            HStack {
                                Text("Estou lendo")
                                    .style(.regular, size: 17)

                                Image(systemName: "book")
                            }
                        case "Já li":
                            HStack {
                                Text("Já li")
                                    .style(.regular, size: 17)

                                Image(systemName: "checkmark.circle")
                            }
                        default:
                            HStack {
                                Text("Remover da lista")
                                    .style(.regular, size: 17)

                                Image(systemName: "trash")
                            }
                        }

                    }
                }
            } label: {
                buttonStack
            }
            .onChange(of: bookInfoViewModel.selectedStatus) { newStatus in
                bookInfoViewModel.status = bookInfoViewModel.setStatusWhenPickerChange(for: newStatus)
                bookInfoViewModel.saveBook()
            }
            .onAppear {
                if let status = bookInfoViewModel.status {
                    selectedStatus = bookInfoViewModel.setSelectedStatusText(for: status)
                }
            }
        }
    }

    var buttonStack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder()
                .frame(width: 187, height: 43)
                .foregroundColor(.secondary)
            HStack {
                switch bookInfoViewModel.status {
                case .want:
                    Image("Livros Quero Ler")
                        .resizable()
                        .frame(width: 16, height: 23)
                        .padding(.leading, 16)
                    Text(bookInfoViewModel.setSelectedStatusText(for: .want))
                        .style(.bold, size: 17)
                        .foregroundColor(ColorAsset.pink.primary)
                        .padding(.leading, 10)
                case .inProgress:
                    Image("Livros Estou Lendo")
                        .resizable()
                        .frame(width: 16, height: 23)
                        .padding(.leading, 16)
                        .foregroundColor(.orange)
                    Text(bookInfoViewModel.setSelectedStatusText(for: .inProgress))
                        .style(.bold, size: 17)
                        .foregroundColor(.orange)
                        .padding(.leading, 10)
                case .read:
                    Image("Livros Lidos")
                        .resizable()
                        .frame(width: 16, height: 23)
                        .padding(.leading, 16)
                        .foregroundColor(ColorAsset.blue.primary)
                    Text(bookInfoViewModel.setSelectedStatusText(for: .read))
                        .style(.bold, size: 17)
                        .foregroundColor(ColorAsset.blue.primary)
                        .padding(.leading, 10)
                default:
                    Text("Adicionar à lista")
                        .style(.regular, size: 17)
                        .foregroundColor(Color(UIColor.systemGray))
                        .padding(.leading, 16)
                }

                Spacer()

                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
                    .padding(.trailing, 13)
            }
        }
        .frame(width: 187, height: 43)
    }

    func setSelectedStatusText(for status: Status) -> String {
        switch status {
        case .want:
            return "Quero ler"
        case .inProgress:
            return "Estou lendo"
        case .read:
            return "Já li"
        }
    }

    func setStatusWhenPickerChange(for selectedStatus: String) -> Status? {
        switch selectedStatus {
        case "Quero ler":
            return .want
        case "Estou lendo":
            return .inProgress
        case "Já li":
            return .read
        default:
            return nil
        }
    }
}

struct BookStatusDropDown_Previews: PreviewProvider {

    static let viewModel = BookInfoViewModel(book: bookInfo)
    static let bookDetails = BookDetails(title: "Sou hétero e sou top",
                                         authors: ["Manuelita", "Virto Balista"],
                                         publisher: "Blabla livros",
                                         publishedDate: "27/03/2000",
                                         description: "O livro mais aguardado na SmartFit",
                                         industryIdentifiers: nil,
                                         pageCount: 250,
                                         imageLinks: nil,
                                         language: "PT-BR",
                                         categories: ["Terror", "Suspense"])

    static let bookInfo = BookInfo(id: "123",
                                   volumeInfo: bookDetails)

    static var previews: some View {
        BookStatusDropDown(bookInfoViewModel: viewModel)
            .previewInterfaceOrientation(.portrait)
    }
}
