import SwiftUI

struct FilterView: View {
    
    @State private var selectedCategory = ""
    @State private var selectedAlcoholic = ""
    @State private var selectedIngredient = ""
    @State private var selectedGlass = ""
    
    @ObservedObject var cocktailViewModel: CocktailViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                categoryFilter
                alcoholicFilter
                ingredientFilter
                glassFilter
                Spacer()
                applyButton
            }
            .padding(.top)
        }
        .onAppear {
            // Fetch available filters when the view appears
            cocktailViewModel.fetchCategories()
            cocktailViewModel.fetchAlcoholicOptions()
            cocktailViewModel.fetchIngredients()
            cocktailViewModel.fetchGlasses()
        }
        .navigationTitle("Filters")
    }
    
    private var categoryFilter: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Category")
                .font(.headline)
                .padding(.bottom, 5)
            ForEach(cocktailViewModel.categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    Text(category)
                        .padding()
                        .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
    }

    private var alcoholicFilter: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Alcoholic")
                .font(.headline)
                .padding(.bottom, 5)
            ForEach(cocktailViewModel.alcoholicOptions, id: \.self) { option in
                Button(action: {
                    selectedAlcoholic = option
                }) {
                    Text(option)
                        .padding()
                        .background(selectedAlcoholic == option ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
    }

    private var ingredientFilter: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Ingredient")
                .font(.headline)
                .padding(.bottom, 5)
            ForEach(cocktailViewModel.ingredients, id: \.self) { ingredient in
                Button(action: {
                    selectedIngredient = ingredient
                }) {
                    Text(ingredient)
                        .padding()
                        .background(selectedIngredient == ingredient ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
    }

    private var glassFilter: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Glass")
                .font(.headline)
                .padding(.bottom, 5)
            ForEach(cocktailViewModel.glasses, id: \.self) { glass in
                Button(action: {
                    selectedGlass = glass
                }) {
                    Text(glass)
                        .padding()
                        .background(selectedGlass == glass ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
    }

    private var applyButton: some View {
        Button(action: {
            applyFilter()
        }) {
            Text("Apply Filters")
                .font(.headline)
                .padding()
                .background((selectedCategory.isEmpty && selectedAlcoholic.isEmpty && selectedIngredient.isEmpty && selectedGlass.isEmpty) ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .frame(maxWidth: .infinity)
        }
        .disabled(selectedCategory.isEmpty && selectedAlcoholic.isEmpty && selectedIngredient.isEmpty && selectedGlass.isEmpty)
        .padding()
    }
    
    private func applyFilter() {
        // Apply the filter based on the selected values
        if !selectedCategory.isEmpty {
            cocktailViewModel.applyFilter(filterType: .category, value: selectedCategory)
        }
        if !selectedAlcoholic.isEmpty {
            cocktailViewModel.applyFilter(filterType: .alcoholic, value: selectedAlcoholic)
        }
        if !selectedIngredient.isEmpty {
            cocktailViewModel.applyFilter(filterType: .ingredient, value: selectedIngredient)
        }
        if !selectedGlass.isEmpty {
            cocktailViewModel.applyFilter(filterType: .glass, value: selectedGlass)
        }
    }
}
