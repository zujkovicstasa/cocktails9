import SwiftUI

struct LoginView: View {
    
    @State private var currentImage = "loginbw2"
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false
    
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
                
                Button(action: handleLogin) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("login_color"))
                        .cornerRadius(8)
                }

                NavigationLink(destination: Text("Registration Coming Soon!")
                    .font(.title)
                    .foregroundColor(.gray)
                    ){
                        
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
        
        if let storedUser = UserManagement.shared.getUser(byEmail: email) {
            
            if storedUser.password == password {
                withAnimation {
                    currentImage = (currentImage == "loginbw2") ? "loginclr2" : "loginbw2"
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    navigateToHome = true
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

}

#Preview {
    LoginView()
}
