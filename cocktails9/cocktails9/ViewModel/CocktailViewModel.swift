import Foundation

import SwiftUI
import Combine

enum FilterType {
    case category
    case alcoholic
    case ingredient
    case glass
    
}
class CocktailViewModel: ObservableObject {
    
    @Published var cocktails: [Cocktail] = []
    private let cocktailService: CocktailService
    private var user: User?
    
    @Published var selectedCategory: String = ""
    @Published var selectedGlass: String = ""
    @Published var selectedIngredient: String = ""
    @Published var firstLetter: String = ""
    @Published var isAlcoholic: String = "Alcoholic"
    
    @Published var categories: [String] = []
    @Published var alcoholicOptions: [String] = []
    @Published var ingredients: [String] = []
    @Published var glasses: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
        
    
    init(cocktailService: CocktailService) {
        self.cocktailService = cocktailService
        if let currentUser = UserManagement.shared.getUser(byEmail: "test@gmail.com") {
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
    
    func fetchCategories() {
            // Replace this with your actual API endpoint for categories
            let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")!
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [String].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { categories in
                    self.categories = categories
                })
                .store(in: &cancellables)
        }
        
    func fetchAlcoholicOptions() {
        // Replace this with your actual API endpoint for alcoholic options
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?a=list")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [String].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { options in
                self.alcoholicOptions = options
            })
            .store(in: &cancellables)
    }
        
    func fetchIngredients() {
        // Replace this with your actual API endpoint for ingredients
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [String].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { ingredients in
                self.ingredients = ingredients
            })
            .store(in: &cancellables)
    }
    
    func fetchGlasses() {
        // Replace this with your actual API endpoint for glasses
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?g=list")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [String].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { glasses in
                self.glasses = glasses
            })
            .store(in: &cancellables)
    }
        
        
    
    func applyFilter(filterType: FilterType, value: String) {
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
                    cocktails = response.drinks
                } catch {
                    print("Error fetching filtered cocktails: \(error)")
                }
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
        guard var user = user else { return }
        
        var updatedCocktail = cocktail
        updatedCocktail.isFavorite.toggle()
        
        // Toggle the favorite status of the cocktail in the user's favorites
        if updatedCocktail.isFavorite {
            if !user.favoriteCocktails.contains(where: { $0.id == updatedCocktail.id }) {
                user.favoriteCocktails.append(updatedCocktail)
            }
        } else {
            user.favoriteCocktails.removeAll { $0.id == updatedCocktail.id }
        }
        
        // Update the user data in UserDefaults
        UserManagement.shared.updateFavorites(forEmail: user.email, favorites: user.favoriteCocktails)
        
        // Update the cocktails list with the new favorite status
        if let index = cocktails.firstIndex(where: { $0.id == cocktail.id }) {
            cocktails[index] = updatedCocktail
        }
    }

}