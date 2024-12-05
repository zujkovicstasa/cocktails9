import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: FiltersViewModel
    var applyFilter: (FilterType, String) -> Void

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Categories")) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Button(action: {
                            applyFilter(.category, category) // Apply category filter
                        }) {
                            Text(category)
                        }
                    }
                }

                Section(header: Text("Alcoholic")) {
                    ForEach(viewModel.alcoholicOptions, id: \.self) { option in
                        Button(action: {
                            applyFilter(.alcoholic, option) // Apply alcoholic filter
                        }) {
                            Text(option)
                        }
                    }
                }

                Section(header: Text("Ingredients")) {
                    ForEach(viewModel.ingredients, id: \.self) { ingredient in
                        Button(action: {
                            applyFilter(.ingredient, ingredient) // Apply ingredient filter
                        }) {
                            Text(ingredient)
                        }
                    }
                }

                Section(header: Text("Glasses")) {
                    ForEach(viewModel.glasses, id: \.self) { glass in
                        Button(action: {
                            applyFilter(.glass, glass) // Apply glass filter
                        }) {
                            Text(glass)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchCategories()
                viewModel.fetchAlcoholicOptions()
                viewModel.fetchIngredients()
                viewModel.fetchGlasses()
            }
        }
    }
}
