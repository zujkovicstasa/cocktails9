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
                Spacer()
        
                Group {
                    switch selectedTab {
                    case .cocktails:
                        cocktailsView()
                    case .favorites:
                        favoritesView()
                    case .profile:
                        profileView()
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

struct TabButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let selectedColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? selectedColor : .secondary)
                Text(label)
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundColor(isSelected ? selectedColor : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
}
