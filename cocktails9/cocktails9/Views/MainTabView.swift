import SwiftUI

struct MainTabView: View {
    enum Tab {
        case cocktails
        case favorites
        case profile
    }
    
    @State private var selectedTab: Tab = .cocktails

    var body: some View {
        NavigationStack {
            VStack {
        
                Group {
                    switch selectedTab {
                    case .cocktails:
                        CocktailsView()
                    case .favorites:
                        FavoritesView()
                    case .profile:
                        ProfileView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                ZStack {
                    Capsule()
                        .fill(Color(.systemGray6))
                        .frame(height: 80)
                        .opacity(0.3)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    
                    HStack {
                        TabButton(
                            icon: "wineglass",
                            label: "Cocktails",
                            isSelected: selectedTab == .cocktails,
                            selectedColor: .orange
                        ) {
                            selectedTab = .cocktails
                        }
                        
                        TabButton(
                            icon: "heart",
                            label: "Favorites",
                            isSelected: selectedTab == .favorites,
                            selectedColor: .red
                        ) {
                            selectedTab = .favorites
                        }
                        
                        TabButton(
                            icon: "person",
                            label: "Profile",
                            isSelected: selectedTab == .profile,
                            selectedColor: .yellow
                        ) {
                            selectedTab = .profile
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
