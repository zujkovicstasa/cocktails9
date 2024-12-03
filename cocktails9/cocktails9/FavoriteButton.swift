import SwiftUI

struct FavoriteButton: View {
    
    @Binding var isFavorite: Bool
    
    var body: some View {
        Button {
            isFavorite.toggle()  // Toggle favorite state
        } label: {
            Label("Toggle Favorite", systemImage: isFavorite ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isFavorite ? .yellow : .gray)
        }
    }
}

#Preview {
    FavoriteButton(isFavorite: .constant(true))
}
