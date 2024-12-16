
class FilterService {
    
    private let networkManager: NetworkManager
    private let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    private enum Api {
            static let categories = "list.php?c=list"
            static let alcoholicOptions = "list.php?a=list"
            static let ingredients = "list.php?i=list"
            static let glasses = "list.php?g=list"
        }
    
    // Fetch Categories
    func fetchCategories() async throws -> [String] {
        let response: CategoriesResponse = try await networkManager.request(from: "\(baseUrl)\(Api.categories)", type: CategoriesResponse.self)
        return response.drinks.map { $0.category }
    }
    
    // Fetch Alcoholic Options
    func fetchAlcoholicOptions() async throws -> [String] {
        let response: AlcoholicOptionsResponse = try await networkManager.request(from: "\(baseUrl)\(Api.alcoholicOptions)", type: AlcoholicOptionsResponse.self)
        return response.drinks.map { $0.alcoholic }
    }
    
    // Fetch Ingredients
    func fetchIngredients() async throws -> [String] {
        let response: IngredientsResponse = try await networkManager.request(from: "\(baseUrl)\(Api.ingredients)", type: IngredientsResponse.self)
        return response.drinks.map { $0.ingredient1 }
    }
    
    // Fetch Glasses
    func fetchGlasses() async throws -> [String] {
        let response: GlassesResponse = try await networkManager.request(from: "\(baseUrl)\(Api.glasses)", type: GlassesResponse.self)
        return response.drinks.map { $0.glass }
    }
}
