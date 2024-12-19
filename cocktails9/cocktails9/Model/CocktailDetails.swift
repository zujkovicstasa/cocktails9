import Foundation

struct CocktailDetails: Decodable {
    let id: String
    let name: String
    let imageURL: String
    let instructions: String?
    let category: String
    let alcoholic: String
    let glass: String

    let ingredientsAndMeasurements: [(ingredient: String, measurement: String)]


    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case imageURL = "strDrinkThumb"
        case instructions = "strInstructions"
        case category = "strCategory"
        case alcoholic = "strAlcoholic"
        case glass = "strGlass"
        // Define CodingKeys for ingredients and measurements
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
             strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
             strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
             strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
             strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        category = try container.decode(String.self, forKey: .category)
        alcoholic = try container.decode(String.self, forKey: .alcoholic)
        glass = try container.decode(String.self, forKey: .glass)

    
        var ingredientsAndMeasurements: [(String, String)] = []
        for index in 1...15 {
            let ingredientKey = CodingKeys(stringValue: "strIngredient\(index)")!
            let measureKey = CodingKeys(stringValue: "strMeasure\(index)")!
            
            let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey) ?? ""
            let measurement = try container.decodeIfPresent(String.self, forKey: measureKey) ?? ""
         
            if !ingredient.isEmpty {
                ingredientsAndMeasurements.append((ingredient, measurement))
            }
        }
        self.ingredientsAndMeasurements = ingredientsAndMeasurements
    }
}

struct CocktailDetailsResponse: Decodable {
    let drinks: [CocktailDetails]
}
