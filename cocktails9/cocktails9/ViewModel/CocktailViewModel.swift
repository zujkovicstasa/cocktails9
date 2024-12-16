import Foundation

import SwiftUI
import Combine

class CocktailViewModel: ObservableObject {
    
    @Published var cocktails: [Cocktail] = []
    @Published var searchQuery: String = ""
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
        guard let user = UserManagement.shared.getLoggedInUser() else { return }
        self.user = user
    }
    
    func toggleFavorite(cocktail: Cocktail) {
        
        guard let currentUser = UserManagement.shared.getLoggedInUser() else {
            print("No logged-in user found.")
            return
        }

        UserManagement.shared.updateFavorites(forLoggedInUserWith: cocktail)
           
       objectWillChange.send()
       updateLoggedInUser()
    }
    
    func performSearch() async {
        do {
            let results = try await cocktailService.searchCocktails(query: searchQuery)
            await MainActor.run {
                self.cocktails = results
            }
        } catch {
            print("Search failed: \(error)")
        }
    }

}
