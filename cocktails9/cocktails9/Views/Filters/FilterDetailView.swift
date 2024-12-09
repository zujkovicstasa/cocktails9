
import Foundation
import SwiftUI

struct FilterDetailView: View {
    var filterType: FilterType
    var data: [String]
    @ObservedObject var cocktailViewModel: CocktailViewModel
    
    var body: some View {
        VStack {
            Text("Filter by \(filterTitle(for: filterType))")
                .font(.headline)
                .padding()

            List(data, id: \.self) { item in
                Button(action: {
                    if cocktailViewModel.activeFilter?.type == filterType && cocktailViewModel.activeFilter?.value == item {
                        // If the selected filter is already active, clear it
                        cocktailViewModel.clearFilter()
                    } else {
                        // Otherwise, apply the new filter
                        cocktailViewModel.applyFilter(filterType: filterType, value: item)
                    }
                }) {
                    HStack {
                        Text(item)
                            .padding(.vertical, 8) // Reduce vertical padding to make it smaller
                            .font(.subheadline) // Use a smaller font
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if cocktailViewModel.activeFilter?.type == filterType && cocktailViewModel.activeFilter?.value == item {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .padding(.leading, 8) // Optional: Adds space between text and checkmark
                        }
                    }
                    .contentShape(Rectangle()) // Ensures the entire HStack is tappable
                }
                .buttonStyle(PlainButtonStyle()) // Removes default button styling
            }
        }
    }

    private func filterTitle(for type: FilterType) -> String {
        switch type {
        case .category:
            return "Category"
        case .alcoholic:
            return "Alcoholic Option"
        case .ingredient:
            return "Ingredient"
        case .glass:
            return "Glass"
        }
    }
}
