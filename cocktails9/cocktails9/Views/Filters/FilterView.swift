import SwiftUI

struct FilterView: View {
    @ObservedObject var filterViewModel: FiltersViewModel
    @ObservedObject var cocktailViewModel: CocktailViewModel
    
    private var filterTypes: [(FilterType, [String])] {
        [
            (.category, filterViewModel.categories),
            (.alcoholic, filterViewModel.alcoholicOptions),
            (.ingredient, filterViewModel.ingredients),
            (.glass, filterViewModel.glasses)
        ]
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Filter Options").font(.headline)) {
                    ForEach(filterTypes, id: \.0) { filterType, data in
                        FilterNavigationLink(
                            filterType: filterType,
                            data: data,
                            filterViewModel: filterViewModel,
                            cocktailViewModel: cocktailViewModel
                        )
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
