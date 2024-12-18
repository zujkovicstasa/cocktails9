import SwiftUI

struct CocktailItemView: View {
    
    @ObservedObject var viewModel: CocktailViewModel
    let cocktail: Cocktail
    @State private var isUpdating = false
    
    var isFavorite: Bool {
            UserManagement.shared.getLoggedInUser()?.favoriteCocktails.contains(where: { $0.id == cocktail.id }) ?? false
        }
    
    init(viewModel: CocktailViewModel, cocktail: Cocktail) {
        self.viewModel = viewModel
        self.cocktail = cocktail
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

            VStack(alignment: .leading, spacing: 8) {
            
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
                    FavoriteButton(isFavorite: isFavorite) {
                        withAnimation {
                            isUpdating = true
                            viewModel.toggleFavorite(cocktail: cocktail)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isUpdating = false
                            }
                        }
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
