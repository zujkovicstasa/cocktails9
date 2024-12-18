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
    @State private var avatarImage: UIImage? // To store the selected image as UIImage
    
    var cocktailService: CocktailService
    var filterService: FilterService
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = user {
                        VStack(spacing: 16) {
                            // Profile Picture Section
                            VStack(spacing: 15) {
                                // Profile Picture with Gradient Background
                                ZStack {
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange.opacity(0.6), Color.red.opacity(0.6)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    
                                    if let avatarImage = avatarImage {
                                        Image(uiImage: avatarImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 140, height: 140)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 140, height: 140)
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                PhotosPicker(
                                    selection: $avatarItem,
                                    matching: .images,
                                    photoLibrary: .shared()) {
                                        Text("Change Avatar")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.black.opacity(0.6))
                                            .cornerRadius(10)
                                    }
                                    .onChange(of: avatarItem) { newItem in
                                        Task {
                                            if let item = newItem {
                                                // Load the selected image as Data first
                                                if let data = try? await item.loadTransferable(type: Data.self),
                                                   let uiImage = UIImage(data: data) {
                                                    avatarImage = uiImage
                                                    
                                                    // Save the avatar image data to the logged-in user
                                                    updateAvatar(data)
                                                    print("Avatar updated!")
                                                }
                                            }
                                        }
                                    }
                            }
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.orange)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                            
                            Button(action: {
                                showingChangePassword.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "lock.fill")
                                    Text("Change Password")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.red]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: .orange.opacity(0.4), radius: 5, x: 0, y: 3)
                            }
                            
                            // Logout Button
                            Button(action: {
                                logout()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.right.square.fill")
                                    Text("Logout")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 3)
                            }
                        }
                        .padding()
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
                // Load the user and the saved avatar image data
                user = UserManagement.shared.getLoggedInUser()
                loadAvatarImage()
                print("User avatar data: \(String(describing: user?.avatarImage))")

            }
            .navigationBarTitle("Profile", displayMode: .inline)
        }
    }
    
    private func loadAvatarImage() {
        // Check if the user has an avatar image saved and load it
        if let avatarData = user?.avatarImage,
           let uiImage = UIImage(data: avatarData) {
            avatarImage = uiImage
        }
    }
    
    private func logout() {
        UserManagement.shared.logout()
        appState.isLoggedIn = false // Update the global state
    }
    
    private func updateAvatar(_ avatarData: Data) {
        guard var currentUser = user else { return }
        currentUser.avatarImage = avatarData
        UserManagement.shared.saveUser(currentUser)
        
        // Ensure the avatar image is updated after saving
        avatarImage = UIImage(data: avatarData)
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
