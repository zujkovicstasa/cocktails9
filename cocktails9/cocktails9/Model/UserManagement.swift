import Foundation

struct User: Codable {
    var email: String
    var password: String
    var favoriteCocktails: [Cocktail]
    var avatarImage: Data?
}

class UserManagement {
    static let shared = UserManagement()
    
    private init() {}
    
    private let loggedInUserKey = "loggedInUserEmail"
    
    func setLoggedInUser(email: String) {
            UserDefaults.standard.set(email, forKey: loggedInUserKey)
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

    func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "user-\(user.email)")
        }
    }
    
    func logout() {
            // Clear the logged-in user's email
            UserDefaults.standard.removeObject(forKey: loggedInUserKey)
        }
    
    func getLoggedInUser() -> User? {
        if let email = UserDefaults.standard.string(forKey: loggedInUserKey) {
            return getUser(byEmail: email)
        }
        return nil
    }

    func updateFavorites(forLoggedInUserWith cocktail: Cocktail) {
        if var currentUser = getLoggedInUser() {
            if let index = currentUser.favoriteCocktails.firstIndex(where: { $0.id == cocktail.id }) {
                currentUser.favoriteCocktails.remove(at: index)
            } else {
                currentUser.favoriteCocktails.append(cocktail)
            }
            saveUser(currentUser)
        }
    }
    
}
