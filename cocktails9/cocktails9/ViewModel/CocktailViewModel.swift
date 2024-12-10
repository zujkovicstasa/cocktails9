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
        if let currentUser = UserManagement.shared.getLoggedInUser() {
           self.user = currentUser
        }
   }
    
    var favoriteCocktails: [Cocktail] {
            guard let user = user else { return [] }
            return cocktails.filter { cocktail in
                user.favoriteCocktails.contains { $0.id == cocktail.id }
            }
        }
    
    func updateLoggedInUser() {
        if let currentUser = UserManagement.shared.getLoggedInUser() {
            self.user = currentUser
            self.loadFavorites()
        } else {
            self.user = nil
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
     
        activeFilter = (type: filterType, value: value)
        
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
            for i in 0..<cocktails.count {
                cocktails[i].isFavorite = user.favoriteCocktails.contains(where: { $0.id == cocktails[i].id })
            }
        }
    
    func toggleFavorite(cocktail: Cocktail) {
        guard var currentUser = UserManagement.shared.getLoggedInUser() else {
            print("No logged-in user found.")
            return
        }
        
        var updatedCocktail = cocktail
        updatedCocktail.isFavorite.toggle()

        if updatedCocktail.isFavorite {
            if !currentUser.favoriteCocktails.contains(where: { $0.id == updatedCocktail.id }) {
                currentUser.favoriteCocktails.append(updatedCocktail)
            }
        } else {
           
            currentUser.favoriteCocktails.removeAll { $0.id == updatedCocktail.id }
        }
        
        UserManagement.shared.saveUser(currentUser)
        
        if let index = cocktails.firstIndex(where: { $0.id == cocktail.id }) {
            cocktails[index] = updatedCocktail
        }
        

    }


}
