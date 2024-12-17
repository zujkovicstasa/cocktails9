import Foundation

class CocktailService {
    
    
    private let networkManager: NetworkManager
    private let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"

    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    private enum Api {
        case filterAlcoholic
        case lookup(id: String)
        case search(query: String)
        
        var endpoint: String {
            switch self {
            case .filterAlcoholic:
                return "filter.php?a=Alcoholic"
            case .lookup(let id):
                return "lookup.php?i=\(id)"
            case .search(let query):
                let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
                return "search.php?s=\(encodedQuery)"
            }
        }
    }
    
    func fetchCocktailsWithFilters(url: String) async throws -> CocktailResponse {
        let response: CocktailResponse = try await networkManager.request(from: url, type: CocktailResponse.self)
        return response
    }
    
    func fetchCocktailsAsync() async throws -> [Cocktail] {
        let endpoint = Api.filterAlcoholic.endpoint
        let response: CocktailResponse = try await networkManager.request(from: baseUrl + endpoint, type: CocktailResponse.self)
        return response.drinks
    }
    
    func fetchCocktailDetails(by id: String) async throws -> CocktailDetails {
        let endpoint = Api.lookup(id: id).endpoint
        let response: CocktailDetailsResponse = try await networkManager.request(from: baseUrl + endpoint, type: CocktailDetailsResponse.self)
        guard let details = response.drinks.first else {
            throw NSError(domain: "No cocktail details found", code: 404, userInfo: nil)
        }
        return details
    }
    
    func searchCocktails(query: String) async throws -> [Cocktail] {
        let endpoint = Api.search(query: query).endpoint
        let response: CocktailResponse = try await networkManager.request(from: baseUrl + endpoint, type: CocktailResponse.self)
        return response.drinks
    }

}
