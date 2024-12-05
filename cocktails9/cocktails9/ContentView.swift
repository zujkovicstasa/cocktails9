//
//  ContentView.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 26.11.24..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let cocktailService = CocktailService()
        let filterService = FilterService()
        CocktailsGridView(cocktailService: cocktailService, filterService: filterService)
    }
}

#Preview {
    ContentView()
}
