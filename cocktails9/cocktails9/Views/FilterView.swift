
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
                // Navigation for Categories
                NavigationLink(
                    destination: FilterDetailView(
                        filterType: .category,
                        data: filterViewModel.categories,
                        cocktailViewModel: cocktailViewModel
                    )
                ) {
                    Text("Categories")
                        .onAppear {
                            Task {
                                await filterViewModel.fetchCategories()
                            }
                        }
                }

                // Navigation for Alcoholic Options
                NavigationLink(
                    destination: FilterDetailView(
                        filterType: .alcoholic,
                        data: filterViewModel.alcoholicOptions,
                        cocktailViewModel: cocktailViewModel
                    )
                ) {
                    Text("Alcoholic Options")
                        .onAppear {
                            Task {
                                await filterViewModel.fetchAlcoholicOptions()
                            }
                        }
                }

                // Navigation for Ingredients
                NavigationLink(
                    destination: FilterDetailView(
                        filterType: .ingredient,
                        data: filterViewModel.ingredients,
                        cocktailViewModel: cocktailViewModel
                    )
                ) {
                    Text("Ingredients")
                        .onAppear {
                            Task {
                                await filterViewModel.fetchIngredients()
                            }
                        }
                }

                // Navigation for Glasses
                NavigationLink(
                    destination: FilterDetailView(
                        filterType: .glass,
                        data: filterViewModel.glasses,
                        cocktailViewModel: cocktailViewModel
                    )
                ) {
                    Text("Glasses")
                        .onAppear {
                            Task {
                                await filterViewModel.fetchGlasses()
                            }
                        }
                }
            }
            .navigationTitle("Filters")
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
