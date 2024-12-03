import SwiftUI

struct FavoriteButton: View {
    
    @Binding var isFavorite: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action() // Call the action to toggle favorite
            isFavorite.toggle() // Update the local state of the favorite
        } label: {
            Label("Toggle Favorite", systemImage: isFavorite ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isFavorite ? .yellow : .gray)
        }
    }
}
