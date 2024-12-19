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
    
    @State private var emailErrorMessage = ""
    @State private var passwordErrorMessage = ""
    @State private var confirmPasswordErrorMessage = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                Spacer(minLength: 0)
                
                // Title
                HStack(spacing: .zero) {
                    Text("Regi")
                    Text("Star")
                        .foregroundColor(Color("register_color"))
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                
                // Email Field
                VStack(alignment: .leading) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textFieldStyle(CustomTextFieldStyle(icon: "at"))
                        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        .onChange(of: email) { _ in validateEmail() }
                    
                    if !emailErrorMessage.isEmpty {
                        Text(emailErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 10)
                    }
                }
                
                // Password Field
                VStack(alignment: .leading) {
                    SecureField("Password", text: $password)
                        .textFieldStyle(CustomTextFieldStyle(icon: "lock"))
                        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        .onChange(of: password) { _ in validatePassword() }
                    
                    if !passwordErrorMessage.isEmpty {
                        Text(passwordErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 10)
                    }
                }
                
                // Confirm Password Field
                VStack(alignment: .leading) {
                    SecureField("Repeat Password", text: $repeatPassword)
                        .textFieldStyle(CustomTextFieldStyle(icon: "lock"))
                        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        .onChange(of: repeatPassword) { _ in validateConfirmPassword() }
                    
                    if !confirmPasswordErrorMessage.isEmpty {
                        Text(confirmPasswordErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 10)
                    }
                }
                
                // Register Button
                Button(action: handleRegister) {
                    Text("Register")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color("register_color") : .gray)
                        .cornerRadius(8)
                        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                }
                .disabled(!isFormValid)
                
                // Navigation Link (Hidden)
                NavigationLink(destination: MainTabView(
                    cocktailService: CocktailService(),
                    filterService: FilterService()
                ), isActive: $navigateToMain) {
                    EmptyView()
                }
                
                // Animated Image
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
            
            // Login Navigation
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
            .padding(.bottom,10)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Computed property to check overall form validity
    private var isFormValid: Bool {
        return Validator.validateEmail(email)
    }
    
    // Validate Email
    private func validateEmail() {
        if email.isEmpty {
            emailErrorMessage = ""
        } else if !Validator.validateEmail(email) {
            emailErrorMessage = "Invalid email format"
        } else {
            emailErrorMessage = ""
        }
    }
    private func validatePassword() {
        switch Validator.validatePassword(password) {
        case .valid:
            passwordErrorMessage = ""
        case .invalid(let errors):
            passwordErrorMessage = "Requires: " + errors.joined(separator: ", ")
        }
    }
    
    // Validate Confirm Password
    private func validateConfirmPassword() {
        if repeatPassword.isEmpty {
            confirmPasswordErrorMessage = ""
        } else if password != repeatPassword {
            confirmPasswordErrorMessage = "Passwords do not match"
        } else {
            confirmPasswordErrorMessage = ""
        }
    }
    
    // Handle Registration
    private func handleRegister() {
        
        guard Validator.validateEmail(email) else {
            alertMessage = "Please enter a valid email."
            showAlert = true
            return
        }
 
        guard password == repeatPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        // Check if user already exists
        if let _ = UserManagement.shared.getUser(byEmail: email) {
            alertMessage = "Email is already registered."
            showAlert = true
            return
        }
        
        // Create new user
        let newUser = User(email: email, password: password, favoriteCocktails: [])
        UserManagement.shared.saveUser(newUser)
        UserManagement.shared.setLoggedInUser(email: email)
        
        // Animate and navigate
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
