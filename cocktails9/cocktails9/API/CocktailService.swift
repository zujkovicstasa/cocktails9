import Foundation

class CocktailService {
    
    private let networkManager: NetworkManager
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchCocktailsWithFilters(url: String) async throws -> CocktailResponse {
        let response: CocktailResponse = try await networkManager.request(from: url, type: CocktailResponse.self)
        return response
    }
    
    func fetchCocktailsAsync() async throws -> [Cocktail] {
        let response: CocktailResponse = try await networkManager.request(from: "\(baseURL)filter.php?a=Alcoholic", type: CocktailResponse.self)
        return response.drinks
    }
}
