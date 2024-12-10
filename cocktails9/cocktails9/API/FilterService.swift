import Foundation

enum Api {
    
    static let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"
    static let categories = "\(baseUrl)list.php?c=list"
    static let alcoholicOptions = "\(baseUrl)list.php?a=list"
    static let ingredients = "\(baseUrl)list.php?i=list"
    static let glasses = "\(baseUrl)list.php?g=list"
    
}

class FilterService {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    private func fetch<T: Codable>(_ url: String, type: T.Type) async throws -> T {
        return try await networkManager.request(from: url, type: T.self)
    }

    func fetchCategories() async throws -> [String] {
        let response: CategoriesResponse = try await fetch(Api.categories, type: CategoriesResponse.self)
        return response.drinks.map { $0.category }
    }

    func fetchAlcoholicOptions() async throws -> [String] {
        let response: AlcoholicOptionsResponse = try await fetch(Api.alcoholicOptions, type: AlcoholicOptionsResponse.self)
        return response.drinks.map { $0.alcoholic }
    }
    
    func fetchIngredients() async throws -> [String] {
        let response: IngredientsResponse = try await fetch(Api.ingredients, type: IngredientsResponse.self)
        return response.drinks.map { $0.ingredient1 }
    }
    
    func fetchGlasses() async throws -> [String] {
        let response: GlassesResponse = try await fetch(Api.glasses, type: GlassesResponse.self)
        return response.drinks.map { $0.glass }
    }
}
