import SwiftUI

struct CocktailItem: View {
    
    @ObservedObject var viewModel: CocktailViewModel
    let cocktail: Cocktail
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: cocktail.imageURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 155, height: 155)
            .cornerRadius(5)
            
            HStack {
                Text(cocktail.name.isEmpty ? "Unknown" : cocktail.name)
                    .foregroundStyle(.primary)
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                FavoriteButton(isFavorite: .constant(cocktail.isFavorite)) {
                    viewModel.toggleFavorite(cocktail: cocktail)
                }
            }
        }
        .padding(5)
    }
}
