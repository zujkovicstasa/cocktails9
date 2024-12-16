import Foundation

class CocktailService {
    
    
    private let networkManager: NetworkManager
    private let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"

    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    private enum Api {
        static let filterAlcoholic = "filter.php?a=Alcoholic"
        static let lookup = "lookup.php?i="
        static let search = "search.php?s="
    }
    
    func fetchCocktailsWithFilters(url: String) async throws -> CocktailResponse {
        let response: CocktailResponse = try await networkManager.request(from: url, type: CocktailResponse.self)
        return response
    }
    
    func fetchCocktailsAsync() async throws -> [Cocktail] {
        let response: CocktailResponse = try await networkManager.request(from: "\(baseUrl)\(Api.filterAlcoholic)", type: CocktailResponse.self)
        return response.drinks
    }
    
    func fetchCocktailDetails(by id: String) async throws -> CocktailDetails {
        let url = "\(baseUrl)\(Api.lookup)\(id)"
        let response: CocktailDetailsResponse = try await networkManager.request(from: url, type: CocktailDetailsResponse.self)
        guard let details = response.drinks.first else {
            throw NSError(domain: "No cocktail details found", code: 404, userInfo: nil)
        }
        return details
    }
    
    func searchCocktails(query: String) async throws -> [Cocktail] {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = "\(baseUrl)\(Api.search)\(encodedQuery)"
            
            let response: CocktailResponse = try await networkManager.request(from: url, type: CocktailResponse.self)
            return response.drinks
        }


}
