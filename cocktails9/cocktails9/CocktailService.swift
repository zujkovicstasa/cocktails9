import Foundation

class CocktailService {
    
    private let networkManager: NetworkManager
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic"
    
    // Inject NetworkManager as a dependency
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchCocktailsAsync() async throws -> [Cocktail] {
        let response: CocktailResponse = try await networkManager.request(from: baseURL, type: CocktailResponse.self)
        return response.drinks
    }
}
