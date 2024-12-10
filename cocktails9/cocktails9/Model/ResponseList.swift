import Foundation

struct CategoriesResponse: Codable {
    let drinks: [Category]
}

struct Category: Codable {
    let category: String
}

struct AlcoholicOptionsResponse: Codable {
    let drinks: [AlcoholicOption]
}

struct AlcoholicOption: Codable {
    let alcoholic: String
}

struct IngredientsResponse: Codable {
    let drinks: [Ingredient]
}

struct Ingredient: Codable {
    let ingredient1: String
}

struct GlassesResponse: Codable {
    let drinks: [Glass]
}

struct Glass: Codable {
    let glass: String
}
