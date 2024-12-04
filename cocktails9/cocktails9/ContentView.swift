import SwiftUI

struct ContentView: View {
    @State private var navigateToMain = false
    
    var body: some View {
        SplashView(navigateToMain: $navigateToMain)
            .fullScreenCover(isPresented: $navigateToMain) {
                MainContentView()
            }
    }
}

#Preview {
    ContentView()
}
