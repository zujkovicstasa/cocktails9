class FilterService {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    // Fetch Categories
    func fetchCategories() async throws -> [String] {
        let url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list"
        let response: CategoriesResponse = try await networkManager.request(from: url, type: CategoriesResponse.self)
        return response.drinks.map { $0.strCategory }
    }
    
    // Fetch Alcoholic Options
    func fetchAlcoholicOptions() async throws -> [String] {
        let url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?a=list"
        let response: AlcoholicOptionsResponse = try await networkManager.request(from: url, type: AlcoholicOptionsResponse.self)
        return response.drinks.map { $0.strAlcoholic }
    }
    
    // Fetch Ingredients
    func fetchIngredients() async throws -> [String] {
        let url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
        let response: IngredientsResponse = try await networkManager.request(from: url, type: IngredientsResponse.self)
        return response.drinks.map { $0.strIngredient1 }
    }
    
    // Fetch Glasses
    func fetchGlasses() async throws -> [String] {
        let url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?g=list"
        let response: GlassesResponse = try await networkManager.request(from: url, type: GlassesResponse.self)
        return response.drinks.map { $0.strGlass }
    }
}
