import Foundation

struct ISBNRequest {

    private let session = URLSession(configuration: .default)

    func request(byBookName bookName: String,
                 page: Int = 0,
                 pageSize: Int = 10,
                 completion: @escaping (GoogleAPIBook) -> Void) {

        let request = BookRequest(name: bookName, page: page, pageSize: pageSize)
        guard let url = request.toURL() else { return }

        session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(GoogleAPIBook.self, from: data)
                    completion(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

    func request(byAuthorName authorName: String,
                 page: Int = 0,
                 pageSize: Int = 10,
                 completion: @escaping (GoogleAPIBook) -> Void) {

        let request = BookRequest(name: "inauthor:\(authorName)", page: page, pageSize: pageSize)
        guard let url = request.toURL() else { return }

        session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(GoogleAPIBook.self, from: data)
                    completion(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

    private func filterBooksWithoutAuthor(books: GoogleAPIBook) -> GoogleAPIBook {
        let filteredList = books.items.filter({ $0.getAuthors() != [] })
        let newGoogleAPIBook = GoogleAPIBook(items: filteredList, totalItems: filteredList.count)
        return newGoogleAPIBook
    }

    func requestBook(byUrl url: String) async throws -> BookInfo? {
        guard let urlLink = URL(string: url) else {
            return nil
        }

        let (data, response) = try await URLSession.shared.data(from: urlLink)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return nil }
        let decodedBook = try JSONDecoder().decode(BookInfo.self, from: data)
        return decodedBook
    }
}

struct BookRequest {

    private let baseURL = "https://www.googleapis.com"
    private let path = "/books/v1/volumes"
    private let searchText: String
    private let startIndex: String
    private let pageSize: String

    private var params: String {
        [searchText, startIndex, pageSize].joined(separator: "&")
    }

    init(name: String, page: Int = 0, pageSize: Int = 10) {

        let nameToRequest = name
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? name

        self.searchText = "q=\(nameToRequest.lowercased())"
        self.startIndex = "startIndex=\(page*pageSize)"
        self.pageSize = "maxResult=\(pageSize)"
    }

    func toURL() -> URL? {
        URL(string: baseURL + path + "?" + params)
    }
}
