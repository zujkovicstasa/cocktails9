import Foundation

import SwiftUI
import Combine

class CocktailViewModel: ObservableObject {
    
    @Published var cocktails: [Cocktail] = []
    private let cocktailService: CocktailService
    
    private var user: User?
    @Published var activeFilter: (type: FilterType, value: String)?
    
    
    
    init(cocktailService: CocktailService) {
        self.cocktailService = cocktailService
        UserManagement.shared.mockLogin(email: "test@example.com")
        if let currentUser = UserManagement.shared.getLoggedInUser() {
           self.user = currentUser
        }
   }
    
    func getCocktails() async {
        do {
            let fetchedCocktails = try await cocktailService.fetchCocktailsAsync()
            DispatchQueue.main.async {
                self.cocktails = fetchedCocktails
                self.loadFavorites()
            }
        } catch {
            print("Error fetching cocktails: \(error)")
        }
    }
    
    func applyFilter(filterType: FilterType, value: String) {
        // Update the active filter
        activeFilter = (type: filterType, value: value)
        
        // Construct the URL with the selected filter
        var urlString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?"
        switch filterType {
        case .category:
            urlString += "c=\(value)"
        case .alcoholic:
            urlString += "a=\(value)"
        case .ingredient:
            urlString += "i=\(value)"
        case .glass:
            urlString += "g=\(value)"
        }
        
        // Fetch the cocktails with the selected filter
        if let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            Task {
                do {
                    let response = try await cocktailService.fetchCocktailsWithFilters(url: encodedUrlString)
                    DispatchQueue.main.async {
                        self.cocktails = response.drinks
                    }
                } catch {
                    print("Error fetching filtered cocktails: \(error)")
                }
            }
        }
    }
    
    func clearFilter() {
        activeFilter = nil
        Task {
            do {
                let fetchedCocktails = try await cocktailService.fetchCocktailsAsync()
                DispatchQueue.main.async {
                    self.cocktails = fetchedCocktails
                }
            } catch {
                print("Error fetching cocktails: \(error)")
            }
        }
    }
    
    func loadFavorites() {
            guard let user = user else { return }
            // Update the favorite status of each cocktail based on the user's favorites
            for i in 0..<cocktails.count {
                cocktails[i].isFavorite = user.favoriteCocktails.contains(where: { $0.id == cocktails[i].id })
                print("Loaded favorites: \(user.favoriteCocktails)")
            }
        }
    
    func toggleFavorite(cocktail: Cocktail) {
        // Fetch the current user
        guard var currentUser = UserManagement.shared.getLoggedInUser() else {
            print("No logged-in user found.")
            return
        }
        
        // Create a copy of the cocktail and toggle its favorite status
        var updatedCocktail = cocktail
        updatedCocktail.isFavorite.toggle()

        // Update the user's favorite cocktails
        if updatedCocktail.isFavorite {
            // Add to favorites if not already present
            if !currentUser.favoriteCocktails.contains(where: { $0.id == updatedCocktail.id }) {
                currentUser.favoriteCocktails.append(updatedCocktail) // Add the cocktail to favorites
            }
        } else {
            // Remove from favorites
            currentUser.favoriteCocktails.removeAll { $0.id == updatedCocktail.id }
        }

        // Save the updated user data
        UserManagement.shared.saveUser(currentUser)
        
        // Update the cocktails list with the new favorite status
        if let index = cocktails.firstIndex(where: { $0.id == cocktail.id }) {
            cocktails[index] = updatedCocktail
        }

        print("Updated favorites for \(currentUser.email): \(currentUser.favoriteCocktails.map { $0.name })")
    }


}
