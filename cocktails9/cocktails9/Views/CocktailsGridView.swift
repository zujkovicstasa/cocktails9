import SwiftUI

struct CocktailsGridView: View {
    
    @StateObject private var viewModel: CocktailViewModel
    private let cocktailService: CocktailService
    
    init(cocktailService: CocktailService) {
        self.cocktailService = cocktailService
        _viewModel = StateObject(wrappedValue: CocktailViewModel(cocktailService: cocktailService))
    }
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.cocktails.isEmpty {
                    ProgressView()
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.cocktails) { cocktail in
                                CocktailItem(cocktail: cocktail)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            .task {
                await viewModel.getCocktails()
            }
        }
    }
}

#Preview {
    CocktailsGridView(cocktailService: CocktailService())
}
