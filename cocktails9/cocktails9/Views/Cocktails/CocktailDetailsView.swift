import SwiftUI

struct CocktailDetailsView: View {
    @ObservedObject var viewModel: CocktailDetailsViewModel
    let cocktailID: String
    
    init(viewModel: CocktailDetailsViewModel, cocktailID: String) {
        self.viewModel = viewModel
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
                        
                        Text(cocktail.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "a.square.fill")
                                    .foregroundColor(.orange)
                                Text("Alcoholic: ")
                                Text("\(cocktail.alcoholic)")
                                    .font(.body)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.orange.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(20)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            

                            HStack {
                                Image(systemName: "book.pages.fill")
                                    .foregroundColor(.orange)
                                Text("Category: ")
                                Text("\(cocktail.category)")
                                    .font(.body)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.orange.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(20)
                            } 
                            .frame(maxWidth: .infinity, alignment: .leading)

                            HStack {
                                Image(systemName: "wineglass")
                                    .foregroundColor(.orange)
                                Text("Glass: ")
                                Text("\(cocktail.glass)")
                                    .font(.body)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.orange.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(20)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
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
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CocktailDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailDetailsView(viewModel: CocktailDetailsViewModel(cocktailService: CocktailService()), cocktailID: "11000")
    }
}
