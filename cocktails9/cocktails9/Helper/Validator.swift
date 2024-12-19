//
//  Validator.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 17.12.24..
//

import Foundation

enum Validator {
    
    static func validateEmail( _ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    static func validatePassword(_ password: String) -> ValidationResult {
           
            var errors: [String] = []
        
            if password.count < 8 {
                errors.append("At least 8 characters")
            }
        
            if !password.contains(where: { $0.isUppercase }) {
                errors.append("One uppercase letter")
            }
     
            if !password.contains(where: { $0.isLowercase }) {
                errors.append("One lowercase letter")
            }
       
            if !password.contains(where: { $0.isNumber }) {
                errors.append("One number")
            }
   
            if errors.isEmpty {
                return .valid
            } else {
                return .invalid(errors)
            }
        }
        
        enum ValidationResult {
            case valid
            case invalid([String])
        }
    }
