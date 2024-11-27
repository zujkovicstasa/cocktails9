import SwiftUI

struct login: View {
    
    @State private var currentImage = "loginbw2"
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToGrid = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Spacer(minLength: 0)
                
                HStack {
                    Text("Lo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.trailing, -7.0)
                    Text("Gin")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.277, saturation: 0.318, brightness: 0.558))
                        
                }
                
                
                HStack {
                    Image(systemName: "at")
                        .foregroundColor(.gray)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal, 40.0)
                
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $password)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal, 40.0)
                
                
                Button(action: handleLogin) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hue: 0.277, saturation: 0.318, brightness: 0.558))
                        .cornerRadius(8)
                        .padding(.horizontal, 40.0)
                            }
                
                
                
                NavigationLink(destination: Text("Registration Coming Soon!")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding()){
                        
                    Text("Register")
                        .foregroundColor(Color(hue: 0.277, saturation: 0.318, brightness: 0.558))
                }
                .padding(.top, 10)
                
                
                Image(currentImage)
                               .resizable()
                               .scaledToFit()
                               .frame(width: 120, height: 120)
                               .animation(.easeInOut, value: currentImage)
                               .padding(.top, 50)
                
                Spacer(minLength: 0)
            }
            
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Failed"), message: Text("Invalid email or password"), dismissButton: .default(Text("OK")))
            }
            
        }
    }
    
    
    private func handleLogin() {
        
        guard !email.isEmpty, !password.isEmpty else {
                    alertMessage = "Please enter both email and password."
                    showAlert = true
                    return
                }
        
        if let accountsData = UserDefaults.standard.array(forKey: "RegisteredAccounts") as? [[String: String]] {
            
                    for account in accountsData {
                        
                        if account["email"] == email, account["password"] == password {
                            withAnimation {
                                        currentImage = (currentImage == "loginbw2") ? "loginclr2" : "loginbw2"
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                navigateToGrid = true
                            }
                            
                            navigateToGrid = true
                            return
                        }
                    }
                }
        alertMessage = "Invalid email or password."
                showAlert = true
        
        
    }
}

#Preview {
    login()
}
