import SwiftUI

struct DiscoverList: View {

    @ObservedObject var viewModel: DiscoverListViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            HeaderView(text: "Viva a Diversidade", fontSize: 24)
                .padding(.top, 16)
                .padding(.leading, 24)
                .padding(.bottom, 13)
            VStack(spacing: 16) {
                if let bookList = viewModel.list {
                    ForEach(bookList, id: \.self) { discoverList in
                        DiscoverView(title: discoverList.title,
                                     description: discoverList.description,
                                     imageURL: viewModel.imageURL(colorScheme: colorScheme,
                                                                  discoverList: discoverList),
                                     imageDescription: discoverList.imageDescription)
                        .onTapGesture {
                            self.viewModel.openList(selectedList: discoverList)
                        }
                        .listRowBackground(Color.clear)
                        .padding(.horizontal, 26)
                    }
                } else {
                    ProgressView()
                }

            }
            .background(Color.clear)
            .padding(.bottom, 16)
        }
    }
}

 struct ListCardDiscover_Previews: PreviewProvider {
    // swiftlint:disable line_length
    static var imageURL = "https://conteudo.imguol.com.br/c/entretenimento/32/2018/01/18/maca-1516308281068_v2_900x506.jpg.webp"
     static var list: [DiscoverListModel] = [
        DiscoverListModel(title: "Título 1",
                          description: "Descrição",
                          imageLight: imageURL,
                          imageDark: imageURL,
                          imageDescription: "Descrição da imagem",
                          booksURL: [],
                          backgroundImageLight: "",
                          backgroundImageDark: "",
                          medal: Medal(title: "", image: "", medalType: .goal)),
        
        DiscoverListModel(title: "Título 1",
                          description: "Descrição",
                          imageLight: imageURL,
                          imageDark: imageURL,
                          imageDescription: "Descrição da imagem",
                          booksURL: [],
                          backgroundImageLight: "",
                          backgroundImageDark: "",
                          medal: Medal(title: "", image: "", medalType: .goal)),
        
        DiscoverListModel(title: "Título 1",
                          description: "Descrição",
                          imageLight: imageURL,
                          imageDark: imageURL,
                          imageDescription: "Descrição da imagem",
                          booksURL: [],
                          backgroundImageLight: "",
                          backgroundImageDark: "",
                          medal: Medal(title: "", image: "", medalType: .goal))
     ]
     static var viewModel = DiscoverListViewModel(list: list, coordinator: CoordinatorSearchObject())

    static var previews: some View {
        DiscoverList(viewModel: viewModel)
    }
 }
