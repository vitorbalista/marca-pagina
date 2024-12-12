import SwiftUI

struct SearchView: View {

    enum Constants {
        static let tertiaryColor = Color(uiColor: UIColor.secondarySystemBackground)
        static let tertiaryLabel = Color(uiColor: UIColor.tertiaryLabel)
    }

    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Rectangle()
                        .frame(height: 1, alignment: .center)
                        .foregroundColor(Constants.tertiaryLabel)
                        .padding(.top, 8)
                        .padding(.horizontal, 16)

                    if viewModel.searchText.isEmpty {
                        DiscoverList(viewModel: viewModel.discoverListViewModel)
                    } else {
                        SearchListView(viewModel: viewModel)
                                                    .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                }
                .navigationTitle("Buscar")
                .navigationBarTitleDisplayMode(.automatic)
                .searchable(text: $viewModel.searchText,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "Digite o nome do livro")
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchViewModel(coordinator: CoordinatorSearchObject()))
    }
}
