import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}
    
    enum NetworkingError: Error {
        case invalidUrl
        case noData
        case decodingFailed(String)
    }


    func request<T: Decodable>(from absoluteURL: String, type: T.Type) async throws -> T {
        guard let url = URL(string: absoluteURL) else {
            throw NetworkingError.invalidUrl
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Print out the raw response for debugging
            if let httpResponse = response as? HTTPURLResponse {
                print("URL: \(absoluteURL)")
                print("Status Code: \(httpResponse.statusCode)")
                print("Response String: \(String(data: data, encoding: .utf8) ?? "Unable to convert to string")")
            }
            
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            print("Decoding Error for URL \(absoluteURL): \(error)")
            throw NetworkingError.decodingFailed(error.localizedDescription)
        }
    }
}
