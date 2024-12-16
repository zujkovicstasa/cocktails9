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
            let fetchedCategories = try await filterService.fetchCategories()
            // Ensure updates happen on the main thread
            DispatchQueue.main.async {
                self.categories = fetchedCategories
            }
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
            let fetchedAlcoholicOptions = try await filterService.fetchAlcoholicOptions()
            // Ensure updates happen on the main thread
            DispatchQueue.main.async {
                self.alcoholicOptions = fetchedAlcoholicOptions
            }
        } catch {
            print("Failed to fetch alcoholic options: \(error)")
        }
        isLoading = false
    }

    // Fetch Ingredients
    func fetchIngredients() async {
        isLoading = true
        do {
            let fetchedIngredients = try await filterService.fetchIngredients()
            // Ensure updates happen on the main thread
            DispatchQueue.main.async {
                self.ingredients = fetchedIngredients
            }
        } catch {
            print("Failed to fetch ingredients: \(error)")
        }
        isLoading = false
    }

    // Fetch Glasses
    func fetchGlasses() async {
        isLoading = true
        do {
            let fetchedGlasses = try await filterService.fetchGlasses()
            // Ensure updates happen on the main thread
            DispatchQueue.main.async {
                self.glasses = fetchedGlasses
            }
        } catch {
            print("Failed to fetch glasses: \(error)")
        }
        isLoading = false
    }
}
