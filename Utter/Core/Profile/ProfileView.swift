//
//  ProfileView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedAvatar: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Avatar
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    if let user = viewModel.user {
                        // Show user's selected avatar
                        Text(selectedAvatar)
                            .font(.system(size: 60))
                    } else {
                        // Show a placeholder loading indicator
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }
                }
                
                if let user = viewModel.user {
                    // Username and Email
                    Text(user.name?.capitalized ?? "User")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(user.email ?? "Email")
                        .font(.system(size: 16))
                        .foregroundColor(Color.purple)
                } else {
                    // Placeholder for Username and Email
                    VStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 24)
                            .cornerRadius(8)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 200, height: 16)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.top)
            
            // Choose Your Avatar Label
            Text("Choose Your Avatar")
                .font(.headline)
                .foregroundColor(Color("AccentColor"))
                .padding(.top)
            
            // Avatar Grid
            AvatarGrid(selectedAvatar: $selectedAvatar)
            
            // Sign Out Button
            Button(action: {
                viewModel.updateAvatar(avatar: selectedAvatar)
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .background(Color("ButtonColor"))
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            try? await viewModel.loadCurrentUser()
            if let user = viewModel.user {
                selectedAvatar = user.avatar ?? "🐵"
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    isDarkMode.toggle()
                    setAppearance()
                }) {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.headline)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color("AppBackgroundColor"))
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    private func setAppearance() {
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
}

#Preview {
    NavigationStack{
        ProfileView(showSignInView: .constant(false))
    }
}
