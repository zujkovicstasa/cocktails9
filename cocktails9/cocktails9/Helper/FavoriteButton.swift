import SwiftUI

struct FavoriteButton: View {
    
    let isFavorite: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Label("Toggle Favorite", systemImage: isFavorite ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isFavorite ? .yellow : .gray)
        }
    }
}
