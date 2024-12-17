class FilterService {
    
    private let networkManager: NetworkManager
    private let baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    private enum Api : String {
        
        case categories = "list.php?c=list"
        case alcoholicOptions = "list.php?a=list"
        case ingredients = "list.php?i=list"
        case glasses  = "list.php?g=list"
        
    }
    
    // Fetch Categories
    func fetchCategories() async throws -> [String] {
        let endpoint = Api.categories
        let response: CategoriesResponse = try await networkManager.request(from: baseUrl + Api.categories.rawValue, type: CategoriesResponse.self)
        return response.drinks.map { $0.category }
    }
    
    // Fetch Alcoholic Options
    func fetchAlcoholicOptions() async throws -> [String] {
        let endpoint = Api.alcoholicOptions
        let response: AlcoholicOptionsResponse = try await networkManager.request(from: baseUrl + Api.alcoholicOptions.rawValue, type: AlcoholicOptionsResponse.self)
        return response.drinks.map { $0.alcoholic }
    }
    
    // Fetch Ingredients
    func fetchIngredients() async throws -> [String] {
        let endpoint = Api.ingredients
        let response: IngredientsResponse = try await networkManager.request(from: baseUrl + Api.ingredients.rawValue, type: IngredientsResponse.self)
        return response.drinks.map { $0.ingredient1 }
    }
    
    // Fetch Glasses
    func fetchGlasses() async throws -> [String] {
        let endpoint = Api.glasses
        let response: GlassesResponse = try await networkManager.request(from: baseUrl + Api.glasses.rawValue, type: GlassesResponse.self)
        return response.drinks.map { $0.glass }
    }
}
