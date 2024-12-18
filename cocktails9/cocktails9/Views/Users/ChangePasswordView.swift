import SwiftUI

struct ChangePasswordView: View {
    
    @Binding var user: User?
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var passwordChangeSuccess: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Change Password")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            SecureField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if !passwordChangeSuccess && !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button(action: changePassword) {
                Text("Change Password")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .font(.subheadline)
            }
            .padding()
            .shadow(radius: 5)
        }
        .padding()
    }
    
    private func changePassword() {
        guard newPassword == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        if var currentUser = user {
            currentUser.password = newPassword
            UserManagement.shared.saveUser(currentUser)
            passwordChangeSuccess = true
            errorMessage = ""
            newPassword = ""
            confirmPassword = ""
        }
    }
}
