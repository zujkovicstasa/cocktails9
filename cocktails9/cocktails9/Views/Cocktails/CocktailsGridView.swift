import Foundation
import SwiftUI

struct CocktailsGridView: View {
    
    @StateObject private var viewModel: CocktailViewModel
    @StateObject private var viewDetailModel: CocktailDetailsViewModel
    @StateObject private var filterViewModel: FiltersViewModel
    private let cocktailService: CocktailService
    private let filterService: FilterService
    @State private var isFilterPresented = false
    @State private var searchText = ""
    @State private var isSearchVisible = false
    @State private var isLoading = true
    @State private var searchTimer: Timer?
    
    init(cocktailService: CocktailService, filterService: FilterService) {
        self.cocktailService = cocktailService
        self.filterService = filterService
        _viewModel = StateObject(wrappedValue: CocktailViewModel(cocktailService: cocktailService))
        _filterViewModel = StateObject(wrappedValue: FiltersViewModel(filterService: filterService))
        _viewDetailModel = StateObject(wrappedValue: CocktailDetailsViewModel(cocktailService: cocktailService))
    }

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                // Search and Filter Bar
                
                    HStack(spacing: 10) {
                        Text("cocktails9")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        // Search Button
                        Button(action: {
                            withAnimation {
                                isSearchVisible.toggle()
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                        
                        // Filter Button
                        Button(action: {
                            isFilterPresented.toggle()
                        }) {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Search Field (Dropdown)
                    if isSearchVisible {
                        TextField("Search cocktails", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                HStack {
                                    Spacer()
                                    if !searchText.isEmpty {
                                        Button(action: {
                                            searchText = ""
                                            Task {
                                                await viewModel.performSearch(query:"")
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                }
                            )
                            .onChange(of: searchText) { newValue, _ in
                                searchTimer?.invalidate()
                                searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                                    Task {
                                        await viewModel.performSearch(query: newValue)
                                    }
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .animation(.easeInOut, value: isSearchVisible)
                            .padding(.horizontal)
                    }
                
                
                // Cocktail Grid
                if isLoading {
                    ProgressView("Loading Cocktails...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 50)
                } else if viewModel.cocktails.isEmpty {
                    Text("No cocktails found.")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(viewModel.cocktails, id: \.id) { cocktail in
                                NavigationLink(destination: CocktailDetailsView(viewModel: viewDetailModel, cocktailID: cocktail.id)) {

                                    CocktailItemView(viewModel: viewModel, cocktail: cocktail)
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .sheet(isPresented: $isFilterPresented) {
                FilterView(filterViewModel: filterViewModel, cocktailViewModel: viewModel)
            }
            .onAppear {
                Task {
                    isLoading = true
                    if viewModel.activeFilter == nil {
                        await viewModel.getCocktails()
                    }
                    isLoading = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                viewModel.searchQuery = searchText
            }
        }
    }
}

struct CocktailsGridTab: View {
    let cocktailService: CocktailService
    let filterService: FilterService

    var body: some View {
        NavigationStack {
            CocktailsGridView(cocktailService: cocktailService, filterService: filterService)
        }
    }
}

#Preview {
    CocktailsGridView(cocktailService: CocktailService(), filterService: FilterService())
}
