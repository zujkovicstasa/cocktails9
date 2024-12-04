//
//  UserManagement.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 2.12.24..
//

import Foundation

struct User: Codable {
    let email: String
    let password: String
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
}

