import SwiftUI

struct CocktailItem: View {
    
    @ObservedObject var viewModel: CocktailViewModel
    @State private var isFavorite: Bool // Local state for isFavorite
    let cocktail: Cocktail
    
    init(viewModel: CocktailViewModel, cocktail: Cocktail) {
        self.viewModel = viewModel
        self.cocktail = cocktail
        _isFavorite = State(initialValue: cocktail.isFavorite) // Initialize the state with cocktail's favorite status
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Background Rectangle
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

            VStack(alignment: .leading, spacing: 8) {
                // Cocktail Image
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: cocktail.imageURL)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(height: 155)
                    .cornerRadius(15, corners: [.topLeft, .topRight])

                    // Favorite Button
                    FavoriteButton(isFavorite: $isFavorite) {
                        viewModel.toggleFavorite(cocktail: cocktail)
                    }
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.8))
                    )
                    .offset(x: -5, y: 5)
                }


                // Cocktail Name
                Text(cocktail.name.isEmpty ? "Unknown" : cocktail.name)
                    .foregroundStyle(.primary)
                    .font(.headline)
                    .truncationMode(.tail)
                    .padding([.leading, .trailing], 8)
            }
        }
        .frame(width: 160, height: 220)
        .padding(5)
    }
}



// Helper to add specific corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
struct CocktailItem_Previews: PreviewProvider {
    static var previews: some View {
        let mockCocktail = Cocktail(
            id: "1",
            name: "Mojito",
            imageURL: "https://www.thecocktaildb.com/images/media/drink/3z6xdi1589574603.jpg",
            isFavorite: false
        )

        let mockViewModel = CocktailViewModel(cocktailService: CocktailService())

        CocktailItem(viewModel: mockViewModel, cocktail: mockCocktail)
            .previewLayout(.sizeThatFits)
    }
}
