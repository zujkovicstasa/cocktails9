import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var user: User?
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var passwordChangeSuccess: Bool = false
    @State private var errorMessage: String = ""
    @State private var showingChangePassword = false
    @State private var avatarItem: PhotosPickerItem? // For photo picker
    @State private var avatarImage: Image? // To store the selected image
    
    var cocktailService: CocktailService
    var filterService: FilterService
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = user {
                        VStack(spacing: 16) {
                            // Profile Picture Section
                            VStack {
                                // Display the profile picture or a placeholder
                                if let avatarImage = avatarImage {
                                    avatarImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .padding()
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                        .padding()
                                }
                                
                                PhotosPicker(
                                    selection: $avatarItem,
                                    matching: .images,
                                    photoLibrary: .shared()) {
                                        Text("Select Avatar")
                                    }
                                    .onChange(of: avatarItem) { newItem in
                                        Task {
                                            // Load the selected image
                                            if let item = newItem {
                                                if let loadedImage = try? await item.loadTransferable(type: Image.self) {
                                                    avatarImage = loadedImage
                                                } else {
                                                    print("Failed to load image")
                                                }
                                            }
                                        }
                                    }
                            }
                            
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
        appState.isLoggedIn = false // Update the global state
    }
}

struct ProfileTab: View {
    var body: some View {
        ProfileView(cocktailService: CocktailService(), filterService: FilterService())
    }
}

#Preview {
    ProfileView(cocktailService: CocktailService(), filterService: FilterService())
}
