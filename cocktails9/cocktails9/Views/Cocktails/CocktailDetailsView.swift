import SwiftUI

struct CocktailDetailsView: View {
    
    @ObservedObject var viewModel: CocktailDetailsViewModel
    @ObservedObject var cocktailViewModel: CocktailViewModel
    let cocktailID: String
    
    @State private var isFavorite: Bool = false
    
    init(viewModel: CocktailDetailsViewModel, cocktailViewModel: CocktailViewModel, cocktailID: String) {
        self.viewModel = viewModel
        self.cocktailViewModel = cocktailViewModel
        self.cocktailID = cocktailID
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let cocktail = viewModel.cocktailDetails {
                    VStack(spacing: 16) {
                        
                        AsyncImage(url: URL(string: cocktail.imageURL)) { image in
                            image.resizable()
                                .scaledToFit()
                                .clipped()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .ignoresSafeArea(edges: .top)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        HStack {
                            Text(cocktail.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer() // This will push the button to the right while keeping space between the text and button
                            
                            FavoriteButton(isFavorite: isFavorite) {
                                toggleFavorite(cocktailDetails: cocktail)
                            }
                            .padding(.trailing) // Adds padding to the button so it doesn’t touch the edge
                        }

                    
                        VStack {
                            CocktailDetailItem(
                                iconName: "a.square.fill",
                                label: "Alcoholic",
                                value: cocktail.alcoholic
                            )
                            
                            CocktailDetailItem(
                                iconName: "book.pages.fill",
                                label: "Category",
                                value: cocktail.category
                            )
                            
                            CocktailDetailItem(
                                iconName: "wineglass",
                                label: "Glass",
                                value: cocktail.glass
                            )
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Ingredients:")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            ForEach(cocktail.ingredientsAndMeasurements, id: \.ingredient) { ingredient, measurement in
                                HStack {
                                    Text(ingredient)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(measurement.isEmpty ? "To taste" : measurement)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            if let instructions = cocktail.instructions {
                                Text("Instructions:")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.top)
                                
                                Text(instructions)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                        
                    }
                } else {
                    Text("Cocktail details not found.")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchDetails(for: cocktailID)
                isFavorite = cocktailViewModel.favoriteCocktails.contains(where: { $0.id == cocktailID })
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    func toggleFavorite(cocktailDetails: CocktailDetails) {
        // Assuming CocktailDetails contains a Cocktail object or can be mapped to one
        let cocktail = Cocktail(id: cocktailDetails.id, name: cocktailDetails.name, imageURL: cocktailDetails.imageURL)
        cocktailViewModel.toggleFavorite(cocktail: cocktail)
        isFavorite.toggle()
    }
}

