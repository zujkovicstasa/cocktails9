import SwiftUI

@main
struct CocktailApp: App {
    @StateObject private var appState = AppState() // AppState will track user login status
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState) // Pass AppState to ContentView and its descendants
        }
    }
}
