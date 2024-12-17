class FilterService {
    
    private let networkManager: NetworkManager
    private let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    private enum Api {
        case categories
        case alcoholicOptions
        case ingredients
        case glasses
        
        var endpoint: String {
            switch self {
            case .categories:
                return "list.php?c=list"
            case .alcoholicOptions:
                return "list.php?a=list"
            case .ingredients:
                return "list.php?i=list"
            case .glasses:
                return "list.php?g=list"
            }
        }
    }
    
    // Fetch Categories
    func fetchCategories() async throws -> [String] {
        let endpoint = Api.categories.endpoint
        let response: CategoriesResponse = try await networkManager.request(from: baseUrl + endpoint, type: CategoriesResponse.self)
        return response.drinks.map { $0.category }
    }
    
    // Fetch Alcoholic Options
    func fetchAlcoholicOptions() async throws -> [String] {
        let endpoint = Api.alcoholicOptions.endpoint
        let response: AlcoholicOptionsResponse = try await networkManager.request(from: baseUrl + endpoint, type: AlcoholicOptionsResponse.self)
        return response.drinks.map { $0.alcoholic }
    }
    
    // Fetch Ingredients
    func fetchIngredients() async throws -> [String] {
        let endpoint = Api.ingredients.endpoint
        let response: IngredientsResponse = try await networkManager.request(from: baseUrl + endpoint, type: IngredientsResponse.self)
        return response.drinks.map { $0.ingredient1 }
    }
    
    // Fetch Glasses
    func fetchGlasses() async throws -> [String] {
        let endpoint = Api.glasses.endpoint
        let response: GlassesResponse = try await networkManager.request(from: baseUrl + endpoint, type: GlassesResponse.self)
        return response.drinks.map { $0.glass }
    }
}
