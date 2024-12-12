import Foundation

enum LocalPath: String {
    case fileName = "UserData", folderName = "Data"
}

extension LocalFileManager: LocalFileManagerProtocol {

    private var fileManager: FileManager { FileManager.default }

    public func save<ObjectType: Encodable>(object: ObjectType,
                                            fileName: String,
                                            folderName: String) throws {

        createFolderIfNeeded(folderName: folderName)

        let data = try JSONEncoder().encode(object)
        guard let url = getURLForFile(name: fileName, folderName: folderName) else {
            return
        }

        DispatchQueue.global().async {
            do {
                try data.write(to: url)
            } catch {
                debugPrint("[DEBUG]: Error while try save file \(fileName). \(error)")
            }
        }
    }

    public func load<ReturnType: Decodable>(fileName: String,
                                            folderName: String) -> ReturnType? {

        guard let url = getURLForFile(name: fileName, folderName: folderName),
              fileManager.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url) else {return nil }

        do {
            return try JSONDecoder().decode(ReturnType.self, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}

extension LocalFileManager {

    private func createFolderIfNeeded(folderName: String) {

        guard let url = getURLForFolder(folderName: folderName) else { return }

        if !fileManager.fileExists(atPath: url.path) {

            do {
                try FileManager
                    .default
                    .createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                debugPrint("[DEBUG]: Error while try create folder \(folderName). \(error)")
            }
        }
    }

    private func getURLForFolder(folderName: String) -> URL? {

        guard let url = FileManager
            .default
            .urls(for: .libraryDirectory, in: .userDomainMask)
            .first else { return nil }

        var marcaPaginaDirectory = url

        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            marcaPaginaDirectory = url.appendingPathComponent(bundleIdentifier)
        }

        return marcaPaginaDirectory
            .appendingPathComponent(folderName)
    }

    private func getURLForFile(name: String, folderName: String) -> URL? {

        guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(name)
    }
}
