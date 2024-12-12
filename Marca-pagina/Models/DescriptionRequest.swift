import Foundation
import SwiftUI

struct DescriptionRequest {

    let session = URLSession(configuration: .default)

    func requestDescription(ISBN: [String], completion: @escaping ([Item]) -> Void) {

        var url = "https://openlibrary.org/api/books?bibkeys="

        for index in 0 ..< ISBN.count {
            url += "ISBN:\(ISBN[index]),"
            if index >= 30 {
                break
            }
        }

        url += "&jscmd=details&format=json"

        guard let url = URL(string: url) else { return }
        session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                do {
                    let decodedData = try JSONDecoder().decode(DescriptionResponse.self, from: data)

                    completion(filterEmptyDescriptions(items: decodedData.descriptionStyles))

                } catch {
                    print(error)
                }
            }
        }.resume()
    }

    private func filterEmptyDescriptions(items: [Item]) -> [Item] {
        let nonNil = items.filter { items in
            items.details.description != nil
        }

        return nonNil
    }
}
