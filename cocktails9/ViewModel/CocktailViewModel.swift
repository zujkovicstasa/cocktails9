import Foundation

class CocktailViewModel: ObservableObject {
    @Published var cocktails: [Cocktail] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let cocktailService: CocktailService

    // Inject CocktailService as a dependency
    init(cocktailService: CocktailService) {
        self.cocktailService = cocktailService
    }

    func fetchCocktails() async {
        isLoading = true
        errorMessage = nil

        do {
            cocktails = try await cocktailService.fetchCocktailsAsync()
        } catch {
            errorMessage = "Failed to fetch cocktails: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
