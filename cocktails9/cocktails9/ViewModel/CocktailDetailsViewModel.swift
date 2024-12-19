import SwiftUI

class CocktailDetailsViewModel: ObservableObject {
    @Published var cocktailDetails: CocktailDetails?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let cocktailService: CocktailService

    init(cocktailService: CocktailService) {
        self.cocktailService = cocktailService
    }

    func fetchDetails(for cocktailID: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        do {
            let details = try await cocktailService.fetchCocktailDetails(by: cocktailID)
            DispatchQueue.main.async {
                self.cocktailDetails = details
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}

