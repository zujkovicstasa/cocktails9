import Foundation

enum FilterType {
    case category
    case alcoholic
    case ingredient
    case glass
    
    var title: String {
        switch self {
        case .category: return "Categories"
        case .alcoholic: return "Alcoholic Options"
        case .ingredient: return "Ingredients"
        case .glass: return "Glasses"
        }
    }
    
    var icon: String {
        switch self {
        case .category: return "list.bullet"
        case .alcoholic: return "waterbottle"
        case .ingredient: return "basket"
        case .glass: return "wineglass"
        }
    }
}
