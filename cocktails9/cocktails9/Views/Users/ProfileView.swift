import SwiftUI

struct ProfileView: View {
    
    @State private var user: User?
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var passwordChangeSuccess: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var showingChangePassword = false
    @Environment(\.dismiss) var dismiss // This is used to dismiss the current view
    
    var cocktailService: CocktailService?
    var filterService: FilterService?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = user {
                        VStack(spacing: 16) {
                            
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Email: \(user.email)")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .shadow(radius: 5)
                            
                            Divider()
                            
                            // Change Password Section
                            Button(action: {
                                showingChangePassword.toggle()
                            }) {
                                Text("Change Password")
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            .shadow(radius: 5)
                            
                            
                            // Logout Button Section
                            Button(action: {
                                logout()
                                dismiss() // Dismiss the current view after logging out
                            }) {
                                Text("Logout")
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .font(.subheadline)
                            }
                            .padding(.top)
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                    } else {
                        Text("User not logged in.")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .sheet(isPresented: $showingChangePassword) {
                    ChangePasswordView(user: $user)
                }
            }
            .onAppear {
                user = UserManagement.shared.getLoggedInUser()
            }
            .navigationBarTitle("Profile", displayMode: .inline)
        }
    }
    
    private func logout() {
        UserManagement.shared.logout()
        user = nil
    }
}

struct ProfileTab: View {
    var body: some View {
        NavigationStack {
            ProfileView()
        }
    }
}

#Preview {
    ProfileView(cocktailService: CocktailService(), filterService: FilterService())
}
