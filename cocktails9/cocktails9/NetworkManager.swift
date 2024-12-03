import Foundation

enum NetworkingError: Error {
    case invalidUrl
    case noData
    case decodingFailed(String)
}

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func request<T: Decodable>(from absoluteURL: String, type: T.Type) async throws -> T {
        guard let url = URL(string: absoluteURL) else {
            throw NetworkingError.invalidUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            throw NetworkingError.decodingFailed(error.localizedDescription)
        }
    }
}
