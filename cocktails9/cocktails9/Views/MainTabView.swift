import SwiftUI

struct MainTabView: View {
    
    enum Tab {
        case cocktails
        case favorites
        case profile
    }
    
    let cocktailService: CocktailService
    let filterService: FilterService
    
    @State private var selectedTab: Tab = .cocktails

    var body: some View {
        NavigationStack {
            VStack (spacing:0){
                ZStack {
                    Group {
                        switch selectedTab {
                        case .cocktails:
                            CocktailsGridTab(cocktailService: cocktailService, filterService: filterService)
                        case .favorites:
                            FavoritesTab(cocktailService: cocktailService)
                        case .profile:
                            ProfileTab()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack {
                        Spacer()
                        ZStack {
                            Capsule()
                                .fill(Color(.systemGray6))
                                .frame(height: 80)
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainTabView(cocktailService: CocktailService(), filterService: FilterService())
}
