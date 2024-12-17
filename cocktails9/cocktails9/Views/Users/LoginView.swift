import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var currentImage = "loginbw2"
    @State private var email = ""
    @State private var password = ""
    @State private var keepMeSignedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToMain = false
    let cocktailService: CocktailService
    let filterService: FilterService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Spacer(minLength: 0)
                
                HStack(spacing: .zero) {
                    Text("Lo")
                    Text("Gin")
                        .foregroundColor(Color("login_color"))
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(CustomTextFieldStyle(icon: "at"))
                   
                
                SecureField("Password", text: $password)
                    .textFieldStyle(CustomTextFieldStyle(icon: "lock"))
                
                Toggle("Keep Me Signed In", isOn: $keepMeSignedIn)
                    .padding(.horizontal)
                
                Button(action: handleLogin) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("login_color"))
                        .cornerRadius(8)
                }
                NavigationLink(destination: MainTabView(cocktailService: CocktailService(), filterService: FilterService()), isActive: $navigateToMain) {
                    EmptyView()
                }
                NavigationLink(destination: RegisterView(cocktailService: CocktailService(), filterService: FilterService())) {
                    Text("Register")
                        .foregroundColor(Color("login_color"))
                }
                
                Image(currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .animation(.easeInOut, value: currentImage)
                    .padding(.top, 50)
                
                Spacer(minLength: 0)
            }
            .padding(70)
            .onAppear(perform: checkAutoLogin)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please enter both email and password."
            showAlert = true
            return
        }
        
        if let storedUser = UserManagement.shared.getUser(byEmail: email) {
            if storedUser.password == password {
                UserManagement.shared.setLoggedInUser(email: email)
                appState.isLoggedIn = true
                
                if keepMeSignedIn {
                    saveLoginState()
                }
                
                withAnimation {
                    currentImage = (currentImage == "loginbw2") ? "loginclr2" : "loginbw2"
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    navigateToMain = true
                    CocktailViewModel(cocktailService: cocktailService).updateLoggedInUser()
                }
            } else {
                alertMessage = "Incorrect password."
                showAlert = true
            }
        } else {
            alertMessage = "No account found with that email."
            showAlert = true
        }
    }
    
    private func saveLoginState() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(email, forKey: "loggedInEmail")
    }
    
    private func checkAutoLogin() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            if let savedEmail = UserDefaults.standard.string(forKey: "loggedInEmail") {
                email = savedEmail
                navigateToMain = true
            }
        }
    }
}


#Preview {
    LoginView(cocktailService: CocktailService(), filterService: FilterService())
        .environmentObject(AppState())
}
