import SwiftUI

struct CocktailItem: View {
    
    @Binding var cocktail: Cocktail
    
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
                
                FavoriteButton(isFavorite: $cocktail.isFavorite)  // Pass the correct Binding here
            }
        }
        .padding(5)
    }
}

#Preview {
    // Here you can preview with a sample cocktail if needed
}
