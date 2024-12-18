//
//  register.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 27.11.24..
//

import SwiftUI

struct RegisterView: View {
    
    @State private var currentImage = "registerbw"
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToMain = false
    let cocktailService: CocktailService
    let filterService: FilterService
    @State private var favoriteCocktails: [Cocktail] = []
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @State private var isConfirmPassword = true
    
    var body: some View {
        
        NavigationStack() {
            VStack(spacing: 15) {
                Spacer(minLength: 0)
                
                HStack(spacing: .zero) {
                    Text("Regi")
                    Text("Star")
                        .foregroundColor(Color("register_color"))
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                
                // Email
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(CustomTextFieldStyle(icon:"at"))
                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                
                // Password
                SecureField("Password", text: $password)
                    .textFieldStyle(CustomTextFieldStyle(icon: "lock"))
                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                
                // Repeat Password
                SecureField("Repeat Password", text: $repeatPassword)
                    .textFieldStyle(CustomTextFieldStyle(icon: "lock"))
                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                
                
                // Register Button
                Button(action: handleRegister) {
                    Text("Register")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("register_color"))
                        .cornerRadius(8)
                        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                }
                NavigationLink(destination: MainTabView(cocktailService: CocktailService(), filterService: FilterService()), isActive: $navigateToMain) {
                    EmptyView() // Hidden NavigationLink
                }
                
                Image(currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .animation(.easeInOut, value: currentImage)
                    .padding(.top, 50)
                    .padding(.leading, 20.0)
                
                Spacer(minLength: 0)
            }
            
            .padding(40)
            
            HStack {
                Text("Already have an account?")
                    .font(.body)
                
                
                Button(action: { dismiss() }) {
                    Text("Login")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color("register_color"))
                }
            }
            .padding(.bottom,10)        }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarBackButtonHidden(true)
            
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
        
        
        if let _ = UserManagement.shared.getUser(byEmail: email) {
                alertMessage = "Email is already registered."
                showAlert = true
                return
            }

        let newUser = User(email: email, password: password, favoriteCocktails: [])
            
        UserManagement.shared.saveUser(newUser)
        
        UserManagement.shared.setLoggedInUser(email: email)

        withAnimation {
            currentImage = (currentImage == "registerbw") ? "registerclr" : "registerbw"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            navigateToMain = true
            CocktailViewModel(cocktailService: cocktailService).updateLoggedInUser()
        }
                        
        
    }
}

#Preview {
    RegisterView(cocktailService: CocktailService(), filterService: FilterService())
}
