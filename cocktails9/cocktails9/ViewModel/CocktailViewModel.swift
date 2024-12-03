import Foundation

import SwiftUI

class CocktailViewModel: ObservableObject {
    
    @Published var cocktails: [Cocktail] = []
    private let cocktailService: CocktailService
    private var user: User?
    
    init(cocktailService: CocktailService) {
        self.cocktailService = cocktailService
        if let currentUser = UserManagement.shared.getUser(byEmail: "test@gmail.com") {
            self.user = currentUser
            self.cocktails = self.cocktails.map { cocktail in
                var updatedCocktail = cocktail
                updatedCocktail.isFavorite = user?.favoriteCocktails.contains(where: { $0.id == cocktail.id }) ?? false
                return updatedCocktail
            }
        }
    }
    
    func getCocktails() async {
        do {
            cocktails = try await cocktailService.fetchCocktailsAsync()
        } catch {
            print("Error fetching cocktails: \(error)")
        }
    }
    
    func toggleFavorite(cocktail: Cocktail) {
        guard var user = user else { return }
        
        var updatedCocktail = cocktail
        updatedCocktail.isFavorite.toggle()
        
        if updatedCocktail.isFavorite {
            if !user.favoriteCocktails.contains(where: { $0.id == updatedCocktail.id }) {
                user.favoriteCocktails.append(updatedCocktail)
            }
        } else {
            user.favoriteCocktails.removeAll { $0.id == updatedCocktail.id }
        }
        
        UserManagement.shared.saveUser(user)
        
        if let index = cocktails.firstIndex(where: { $0.id == cocktail.id }) {
            cocktails[index] = updatedCocktail
        }
    }
}
