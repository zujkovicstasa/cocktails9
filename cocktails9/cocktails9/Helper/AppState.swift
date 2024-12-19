import Foundation

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    
    init() {
        // Load the persisted login state only if "Keep Me Signed In" is enabled
        let keepMeSignedIn = UserDefaults.standard.bool(forKey: "keepMeSignedIn")
        if keepMeSignedIn {
            self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        } else {
            self.isLoggedIn = false
        }
    }
    
    func logout() {
        // Clear login state and keepMeSignedIn if the user explicitly logs out
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set(false, forKey: "keepMeSignedIn")
        isLoggedIn = false
        UserManagement.shared.logout() // Clear user session
    }
}
