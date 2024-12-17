import Foundation

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    
    init() {
        // Load the persisted login state
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func logout() {
        isLoggedIn = false
        UserManagement.shared.logout() // Clear user session
    }
}
