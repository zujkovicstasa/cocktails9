import Foundation
import SwiftUI

struct CocktailsGridView: View {
    
    @StateObject private var viewModel: CocktailViewModel
    @StateObject private var filterViewModel: FiltersViewModel
    private let cocktailService: CocktailService
    private let filterService: FilterService // Add this property
    @State private var isFilterPresented = false
    @State private var searchText = ""
    @State private var showSearchField = false

    init(cocktailService: CocktailService, filterService: FilterService) {
        self.cocktailService = cocktailService
        self.filterService = filterService // Initialize filterService here
        _viewModel = StateObject(wrappedValue: CocktailViewModel(cocktailService: cocktailService))
        _filterViewModel = StateObject(wrappedValue: FiltersViewModel(filterService: filterService)) // Pass filterService to FiltersViewModel
    }

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Search Button and TextField
                    Button(action: {
                        withAnimation {
                            showSearchField.toggle()
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .foregroundColor(.black)
                    }

                    if showSearchField {
                        TextField("Search", text: $searchText)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Filter Button
                    Button(action: {
                        isFilterPresented.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .padding()
                            .foregroundColor(.black)
                    }
                }

                // Show list of cocktails
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.cocktails, id: \.id) { cocktail in
                            CocktailItem(viewModel: viewModel, cocktail: cocktail)
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $isFilterPresented) {
                FilterView(filterViewModel: filterViewModel, cocktailViewModel: viewModel)
            }
            .task {
                await viewModel.getCocktails()
            }
        }
    }
}

#Preview {
    CocktailsGridView(cocktailService: CocktailService(), filterService: FilterService()) // Pass the filterService instance here
}
