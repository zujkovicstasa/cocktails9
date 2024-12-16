import SwiftUI

// ViewModel for Filters
class FiltersViewModel: ObservableObject {
    @Published var categories: [String] = []
    @Published var alcoholicOptions: [String] = []
    @Published var ingredients: [String] = []
    @Published var glasses: [String] = []
    @Published var isLoading = false

    private let filterService: FilterService

    init(filterService: FilterService) {
        self.filterService = filterService
    }

    // Fetch Categories
    func fetchCategories() async {
        isLoading = true
        do {
            categories = try await filterService.fetchCategories()
        } catch {
            print("Full error details: \(error)")
            print("Failed to fetch categories: \(error)")
        }
        isLoading = false
    }

    // Fetch Alcoholic Options
    func fetchAlcoholicOptions() async {
        isLoading = true
        do {
            alcoholicOptions = try await filterService.fetchAlcoholicOptions()
        } catch {
            print("Failed to fetch alcoholic options: \(error)")
        }
        isLoading = false
    }

    // Fetch Ingredients
    func fetchIngredients() async {
        isLoading = true
        do {
            ingredients = try await filterService.fetchIngredients()
        } catch {
            print("Failed to fetch ingredients: \(error)")
        }
        isLoading = false
    }

    // Fetch Glasses
    func fetchGlasses() async {
        isLoading = true
        do {
            glasses = try await filterService.fetchGlasses()
        } catch {
            print("Failed to fetch glasses: \(error)")
        }
        isLoading = false
    }
}
