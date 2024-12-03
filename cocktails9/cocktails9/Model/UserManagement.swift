
import Foundation

struct User: Codable {
    
    let email: String
    let password: String
    var favoriteCocktails: [Cocktail] // List of Cocktail structs
}

class UserManagement {
    static let shared = UserManagement()
    
    private init() {}
    
    func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "user-\(user.email)")
        }
    }
    
    func getUser(byEmail email: String) -> User? {
        if let savedUserData = UserDefaults.standard.data(forKey: "user-\(email)") {
            let decoder = JSONDecoder()
            if let decodedUser = try? decoder.decode(User.self, from: savedUserData) {
                return decodedUser
            }
        }
        return nil
    }
    
    // Update the user's list of favorite cocktails
    func updateFavorites(forEmail email: String, favorites: [Cocktail]) {
        if var user = getUser(byEmail: email) {
            user.favoriteCocktails = favorites
            saveUser(user)
        }
    }
}
