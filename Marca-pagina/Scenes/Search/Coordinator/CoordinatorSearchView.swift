import SwiftUI

struct CoordinatorSearchView: View {

    @ObservedObject var object: CoordinatorSearchObject

    var body: some View {
        NavigationView {
            SearchView(viewModel: object.searchViewModel)
                .navigation(item: $object.booksDetailedListViewModel, destination: { viewModel in
                    DiscoverBooks(viewModel: viewModel)
                })
                .sheet(item: $object.bookInfoViewModel) { bookInfoViewModel in
                    BookInfoView(viewModel: bookInfoViewModel)
            }
        }
    }
}
