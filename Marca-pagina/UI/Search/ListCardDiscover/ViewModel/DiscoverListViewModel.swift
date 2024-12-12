import Foundation
import SwiftUI

final class DiscoverListViewModel: ObservableObject {

    @Published private(set) var list: [DiscoverListModel]?
    private unowned let coordinator: CoordinatorSearchObject

    init(list: [DiscoverListModel]? = nil, coordinator: CoordinatorSearchObject) {
        // This attribution is used to inject the mock for preview
        self.coordinator = coordinator
        //        if LocalFileManager.shared.discoverLists.isEmpty {
        loadDiscoverList()
        //        } else {
        //            self.list = LocalFileManager.shared.discoverLists
        //        }
    }

    func imageURL(colorScheme: ColorScheme, discoverList: DiscoverListModel) -> String {
        var imageURL: String {
            if colorScheme == .dark {
                let darkImage = discoverList.imageDark
                return darkImage
            } else {
                let imageLight = discoverList.imageLight
                return imageLight
            }
        }

        return imageURL
    }

    private func loadDiscoverList() {
        Task {
            let list: [DiscoverListModel] = await FirestoreManager().getData(from: "DiscoverList")
            DispatchQueue.main.async {
                self.list = list
            }
        }
    }

    func openList(selectedList: DiscoverListModel) {
        self.coordinator.open(selectedList)
    }
}
