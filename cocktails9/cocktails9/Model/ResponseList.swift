struct CategoriesResponse: Codable {
    let drinks: [Category]
}

struct Category: Codable {
    let strCategory: String
    
    var category: String {
        return strCategory
    }
}

struct AlcoholicOptionsResponse: Codable {
    let drinks: [AlcoholicOption]
}

struct AlcoholicOption: Codable {
    let strAlcoholic: String
    
    var alcoholic: String {
        return strAlcoholic
    }
}

struct IngredientsResponse: Codable {
    let drinks: [Ingredient]
}

struct Ingredient: Codable {
    let strIngredient1: String
    
    var ingredient1: String {
        return strIngredient1
    }
}

struct GlassesResponse: Codable {
    let drinks: [Glass]
}

struct Glass: Codable {
    let strGlass: String
    
    var glass: String {
        return strGlass
    }
}
