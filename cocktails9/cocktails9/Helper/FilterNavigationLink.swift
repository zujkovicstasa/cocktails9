import SwiftUI

struct FilterNavigationLink: View {
    let filterType: FilterType
    let data: [String]
    @ObservedObject var filterViewModel: FiltersViewModel
    @ObservedObject var cocktailViewModel: CocktailViewModel
    
    var body: some View {
        NavigationLink(
            destination: FilterDetailView(
                filterType: filterType,
                data: data,
                cocktailViewModel: cocktailViewModel
            )
        ) {
            Label(filterType.title, systemImage: filterType.icon)
        }
        .onAppear {
            Task {
                switch filterType {
                case .category:
                    await filterViewModel.fetchCategories()
                case .alcoholic:
                    await filterViewModel.fetchAlcoholicOptions()
                case .ingredient:
                    await filterViewModel.fetchIngredients()
                case .glass:
                    await filterViewModel.fetchGlasses()
                }
            }
        }
    }
}
