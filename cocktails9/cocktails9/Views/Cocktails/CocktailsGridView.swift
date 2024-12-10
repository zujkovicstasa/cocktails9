import Foundation
import SwiftUI

struct CocktailsGridView: View {
    
    @StateObject private var viewModel: CocktailViewModel
    @StateObject private var filterViewModel: FiltersViewModel
    private let cocktailService: CocktailService
    private let filterService: FilterService
    @State private var isFilterPresented = false
    @State private var searchText = ""
    @State private var showSearchField = false
    @State private var isLoading = true

    init(cocktailService: CocktailService, filterService: FilterService) {
        self.cocktailService = cocktailService
        self.filterService = filterService
        _viewModel = StateObject(wrappedValue: CocktailViewModel(cocktailService: cocktailService))
        _filterViewModel = StateObject(wrappedValue: FiltersViewModel(filterService: filterService))
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
                    if showSearchField {
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
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                }
                            )
                            .animation(.easeInOut, value: showSearchField)
                    } else {
                        Button(action: {
                            withAnimation {
                                showSearchField.toggle()
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
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
                            ForEach(viewModel.cocktails.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }, id: \.id) { cocktail in
                                NavigationLink{
                                    
                                    CocktailDetails()
                                    
                                } label: {
                                    CocktailItem(viewModel: viewModel, cocktail: cocktail)
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
                    await viewModel.getCocktails()
                    isLoading = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CocktailsGridView(cocktailService: CocktailService(), filterService: FilterService())
}
