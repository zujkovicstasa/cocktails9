//
//  register.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 27.11.24..
//

import SwiftUI

struct register: View {
    @State private var currentImage = "registerbw"
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToGrid = false
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer(minLength: 0)
            
            HStack {
                Text("Regi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.trailing, -7.0)
                Text("Star")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.996, green: 0.488, blue: 0.267))
            }
            // Email
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal, 40.0)
            
            // Password
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                SecureField("Password", text: $password)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal, 40.0)
            
            // Repeat Password
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                SecureField("Repeat Password", text: $repeatPassword)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal, 40.0)
            
            // Register Button
            Button(action: handleRegister) {
                Text("Register")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.996, green: 0.488, blue: 0.267))
                    .cornerRadius(8)
                    .padding(.horizontal, 40.0)
            }
            
            Image(currentImage)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .animation(.easeInOut, value: currentImage)
                .padding(.top, 50)
                .padding(.leading, 20.0)
            
            
            HStack {
                Text("Already have an account?")
                    .font(.body)
                NavigationLink(destination: Text("Login Page")) {
                    Text("Login")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.996, green: 0.488, blue: 0.267))
                }
            }
            .padding(.top, 20)
                                
            
            Spacer(minLength: 0)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func handleRegister() {
        guard !email.isEmpty, !password.isEmpty, !repeatPassword.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        guard password == repeatPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        var accounts = UserDefaults.standard.array(forKey: "RegisteredAccounts") as? [[String: String]] ?? []
        
        if accounts.contains(where: { $0["email"] == email }) {
            alertMessage = "Email is already registered."
            showAlert = true
            return
        }
        
        accounts.append(["email": email, "password": password])
        UserDefaults.standard.set(accounts, forKey: "RegisteredAccounts")
        
        withAnimation {
            currentImage = (currentImage == "registerbw") ? "registerclr" : "registerbw"
        }
                        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            navigateToGrid = true
        }
            
            alertMessage = "Account registered successfully!"
            showAlert = true
        }
}

#Preview {
    register()
}
