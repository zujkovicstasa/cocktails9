import SwiftUI

struct CocktailsGridView: View {
    
    @StateObject private var viewModel: CocktailViewModel
    private let cocktailService: CocktailService
    @State private var isFilterPresented = false
    @State private var searchText = ""
    @State private var showSearchField = false
    
    init(cocktailService: CocktailService) {
        self.cocktailService = cocktailService
        _viewModel = StateObject(wrappedValue: CocktailViewModel(cocktailService: cocktailService))
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
                            showSearchField.toggle() // Toggle search text field visibility
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
                //.padding()
                
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
                FilterView(cocktailViewModel: viewModel)
            }
            .task {
                await viewModel.getCocktails() // Initial fetch when the view appears
            }
        }
    }
}

#Preview {
    CocktailsGridView(cocktailService: CocktailService())
}
