import SwiftUI

struct ContentView: View {
    @State private var navigateToLogin = false
    
    var body: some View {
        SplashView(navigateToLogin: $navigateToLogin)
            .fullScreenCover(isPresented: $navigateToLogin) {
                LoginView()
            }
    }
}

#Preview {
    ContentView()
}
