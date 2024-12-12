import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import FirebaseAuth

enum FirebaseError: Error {
    case fetchError
    case createError
}

struct FirestoreManager {
    private let dbCloud = Firestore.firestore()
    private let dbStorage = Storage.storage()

    func getData<T: Codable>(from collection: String) async -> [T] {
        await withCheckedContinuation { continuation in
            getData(from: collection) { (result: Result<[T], FirebaseError>) in
                switch result {
                case let .success(success):
                    continuation.resume(returning: success)
                case .failure:
                    continuation.resume(returning: [])
                }
            }
        }
    }

    func getData<T: Codable>(from collection: String, documentID: String) async -> T? {
        await withCheckedContinuation { continuation in
            getDocument(from: collection, id: documentID) { (result: Result<T?, FirebaseError>) in
                switch result {
                case let .success(success):
                    continuation.resume(returning: success)
                case .failure:
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    private func getDocument<T: Codable>(
        from collection: String,
        id documentID: String,
        completion: @escaping (Result<T?, FirebaseError>) -> Void
    ) {

        let ref = dbCloud.collection(collection).document(documentID)

        ref.getDocument { document, error in
            if let error = error {
                print("Error getting documents. \(error.localizedDescription)")
                completion(.failure(FirebaseError.fetchError))
            } else {
                do {
                    guard let document = document else {
                        completion(.failure(FirebaseError.fetchError))
                        return
                    }
                    let decodedDocument = try document.data(as: T.self)
                    completion(.success(decodedDocument))
                } catch {
                    completion(.failure(FirebaseError.fetchError))
                }
            }
        }
    }

    private func getData<T: Codable>(
        from collection: String,
        completion: @escaping (Result<[T], FirebaseError>) -> Void
    ) {
        var array: [T] = []

        let ref = dbCloud.collection(collection)

        ref.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents. \(error.localizedDescription)")
                completion(.failure(FirebaseError.fetchError))
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    completion(.success([]))
                    return
                }

                array = documents.compactMap { queryDocumentSnapshot -> T? in
                    return try? queryDocumentSnapshot.data(as: T.self)
                }
                completion(.success(array))
            }
        }
    }

    func downloadFile(from path: String) async -> UIImage? {
        await withCheckedContinuation { continuation in
            downloadFile(from: path) { (result: Result<Data, FirebaseError>) in
                switch result {
                case let .success(success):
                    continuation.resume(returning: UIImage(data: success))
                case .failure:
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    private func downloadFile(
        from path: String,
        completion: @escaping (Result<Data, FirebaseError>) -> Void
    ) {
        let photoReference = dbStorage.reference(withPath: path)

        photoReference.getData(maxSize: 20 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error getting documents. \(error.localizedDescription)")
                completion(.failure(FirebaseError.fetchError))
            } else {
                guard let safeData = data else { return }
                print("Baixei imagem")
                completion(.success(safeData))
            }
        }
    }

    func setData(userData: UserData) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            try dbCloud.collection("UserData").document(userId).setData(from: userData)
        } catch {
            print("Error writing document: \(error)")
        }
    }

    func createUser(userData: UserData) {
        do {
            try dbCloud.collection("UserData").document(userData.userID).setData(from: userData)
        } catch {
            print("Error writing document: \(error)")
        }
    }
}
