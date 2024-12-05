import SwiftUI
import Combine
import Foundation

class FiltersViewModel: ObservableObject {
    @Published var categories: [String] = []
    @Published var alcoholicOptions: [String] = []
    @Published var ingredients: [String] = []
    @Published var glasses: [String] = []
    
    @Published var selectedFilters: [String: String] = [:] // Tracks selected filters for each group
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCategories() {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CategoriesResponse.self, decoder: JSONDecoder())
            .map { $0.drinks.map { $0.strCategory } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching categories: \(error)")
                }
            }, receiveValue: { [weak self] categories in
                self?.categories = categories
            })
            .store(in: &cancellables)
    }
    
    func fetchAlcoholicOptions() {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?a=list")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CategoriesResponse.self, decoder: JSONDecoder())
            .map { $0.drinks.map { $0.strCategory } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching alcoholic options: \(error)")
                }
            }, receiveValue: { [weak self] options in
                self?.alcoholicOptions = options
            })
            .store(in: &cancellables)
    }
    
    func fetchIngredients() {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CategoriesResponse.self, decoder: JSONDecoder())
            .map { $0.drinks.map { $0.strCategory } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching ingredients: \(error)")
                }
            }, receiveValue: { [weak self] ingredients in
                self?.ingredients = ingredients
            })
            .store(in: &cancellables)
    }
    
    func fetchGlasses() {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?g=list")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CategoriesResponse.self, decoder: JSONDecoder())
            .map { $0.drinks.map { $0.strCategory } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching glasses: \(error)")
                }
            }, receiveValue: { [weak self] glasses in
                self?.glasses = glasses
            })
            .store(in: &cancellables)
    }
}

struct CategoriesResponse: Decodable {
    let drinks: [Category]
}

struct Category: Decodable {
    let strCategory: String
}
