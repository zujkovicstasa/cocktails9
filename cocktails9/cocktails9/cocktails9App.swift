//
//  cocktails9App.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 26.11.24..
//

import SwiftUI

@main
struct CocktailApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                MainTabView(cocktailService: CocktailService(), filterService: FilterService())
                    .environmentObject(appState)
            } else {
                LoginView(cocktailService: CocktailService(), filterService: FilterService())
                    .environmentObject(appState)
            }
        }
    }
}
