
import Foundation
import SwiftUI

enum FilterType {
    case category
    case alcoholic
    case ingredient
    case glass
    
}

struct FilterView: View {
    @ObservedObject var filterViewModel: FiltersViewModel
    @ObservedObject var cocktailViewModel: CocktailViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Filter Options").font(.headline)) {
                    // Navigation for Categories
                    NavigationLink(destination: FilterDetailView(
                        filterType: .category,
                        data: filterViewModel.categories,
                        cocktailViewModel: cocktailViewModel
                    )) {
                        Label("Categories", systemImage: "list.bullet")
                    }
                    .onAppear {
                        Task {
                            await filterViewModel.fetchCategories()
                        }
                    }

                    // Navigation for Alcoholic Options
                    NavigationLink(destination: FilterDetailView(
                        filterType: .alcoholic,
                        data: filterViewModel.alcoholicOptions,
                        cocktailViewModel: cocktailViewModel
                    )) {
                        Label("Alcoholic Options", systemImage: "waterbottle")
                    }
                    .onAppear {
                        Task {
                            await filterViewModel.fetchAlcoholicOptions()
                        }
                    }

                    // Navigation for Ingredients
                    NavigationLink(destination: FilterDetailView(
                        filterType: .ingredient,
                        data: filterViewModel.ingredients,
                        cocktailViewModel: cocktailViewModel
                    )) {
                        Label("Ingredients", systemImage: "basket")
                    }
                    .onAppear {
                        Task {
                            await filterViewModel.fetchIngredients()
                        }
                    }

                    // Navigation for Glasses
                    NavigationLink(destination: FilterDetailView(
                        filterType: .glass,
                        data: filterViewModel.glasses,
                        cocktailViewModel: cocktailViewModel
                    )) {
                        Label("Glasses", systemImage: "wineglass")
                    }
                    .onAppear {
                        Task {
                            await filterViewModel.fetchGlasses()
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func fetchData(for filterType: FilterType) -> [String] {
        switch filterType {
        case .category:
            return filterViewModel.categories
        case .alcoholic:
            return filterViewModel.alcoholicOptions
        case .ingredient:
            return filterViewModel.ingredients
        case .glass:
            return filterViewModel.glasses
        }
    }

    private func filterTitle(for filterType: FilterType) -> String {
        switch filterType {
        case .category:
            return "Categories"
        case .alcoholic:
            return "Alcoholic Options"
        case .ingredient:
            return "Ingredients"
        case .glass:
            return "Glasses"
        }
    }
}
