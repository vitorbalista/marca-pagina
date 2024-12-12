import Foundation
import Combine

protocol ListenToUser: AnyObject {
    var bag: Set<AnyCancellable> { get set }

    func listenUserData()
    func refreshData()
}

extension ListenToUser {
     func listenUserData() {
        LocalFileManager
            .shared
            .$userData
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] _ in
                self?.refreshData()
            })
            .store(in: &bag)
    }
}
