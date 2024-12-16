//
//  Cocktail.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 2.12.24..
//

import Foundation

struct Cocktail: Codable, Identifiable {
    
    let id: String
    let name: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case imageURL = "strDrinkThumb"
    }
}

struct CocktailResponse: Decodable {
    let drinks: [Cocktail]
}
