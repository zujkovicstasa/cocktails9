import SwiftUI

struct ContentView: View {
    @State private var navigateToLogin = false
    @EnvironmentObject var appState: AppState // Access the appState
    
    var body: some View {
        VStack {
            if appState.isLoggedIn {
                if !navigateToLogin {
                    SplashView(navigateToLogin: $navigateToLogin)
                } else {
                    MainTabView(
                        cocktailService: CocktailService(),
                        filterService: FilterService()
                    )
                    .environmentObject(appState)
                }
            } else {
                if !navigateToLogin {
                    SplashView(navigateToLogin: $navigateToLogin) // Show splash screen first
                } else {
                    LoginView(
                        cocktailService: CocktailService(),
                        filterService: FilterService()
                    )
                    .environmentObject(appState) // Ensure appState is available in LoginView
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
