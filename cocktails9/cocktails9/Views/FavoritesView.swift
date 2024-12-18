//
//  favoritesView.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 28.11.24..
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject private var viewModel: CocktailViewModel
    @StateObject private var viewDetailModel: CocktailDetailsViewModel
    private let cocktailService: CocktailService
    @State private var isLoading = true
    
    init(cocktailService: CocktailService) {
        self.cocktailService = cocktailService
        _viewModel = StateObject(wrappedValue: CocktailViewModel(cocktailService: cocktailService))
        _viewDetailModel = StateObject(wrappedValue: CocktailDetailsViewModel(cocktailService: cocktailService))
    }

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // Title
                HStack(spacing:10){
                    Text("Favorites")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.leading, 25)
                    Spacer()
                }
                
                
                // Loading or no favorites
                if isLoading {
                    ProgressView("Loading Favorites...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 50)
                } else if viewModel.favoriteCocktails.isEmpty {
                    Text("No favorites yet.")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(viewModel.favoriteCocktails, id: \.id) { cocktail in
                                NavigationLink{
                                    
                                    CocktailDetailsView(viewModel: viewDetailModel, cocktailID: cocktail.id)
                                    
                                } label: {
                                    CocktailItemView(viewModel: viewModel, cocktail: cocktail)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                Task {
                    isLoading = true
                    await viewModel.getCocktails()
                    isLoading = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FavoritesTab: View {
    let cocktailService: CocktailService

    var body: some View {
        NavigationStack {
            FavoritesView(cocktailService: cocktailService)
        }
    }
}

#Preview {
    FavoritesView(cocktailService: CocktailService())
}
