import Foundation

struct CategoriesResponse: Codable {
    let drinks: [Category]
}

struct Category: Codable {
    let strCategory: String
}

struct AlcoholicOptionsResponse: Codable {
    let drinks: [AlcoholicOption]
}

struct AlcoholicOption: Codable {
    let strAlcoholic: String
}

struct IngredientsResponse: Codable {
    let drinks: [Ingredient]
}

struct Ingredient: Codable {
    let strIngredient1: String
}

struct GlassesResponse: Codable {
    let drinks: [Glass]
}

struct Glass: Codable {
    let strGlass: String
}
