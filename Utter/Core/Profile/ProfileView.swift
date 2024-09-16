//
//  ProfileView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func updateAvatar(avatar: String)  {
        guard let user else { return }
        Task {
            try await UserManager.shared.updateUserAvatarStatus(userId: user.userId, avatar: avatar)
            self.user = try await UserManager.shared.getUser(userId: user.userId) // refetch user from database
        }
    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedAvatar: String = "🐵" // TODO: set this from database
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // Profile Avatar
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Text(selectedAvatar)
                        .font(.system(size: 60))
                }
                
                if let user = viewModel.user {
                    // Username and Email
                    Text(user.name?.capitalized ?? "User")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(user.email ?? "Email")
                        .font(.system(size: 16))
                        .foregroundColor(Color.purple)
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
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color("AppBackgroundColor"))
    }
    
}

#Preview {
    NavigationStack{
        ProfileView(showSignInView: .constant(false))
    }
    
}
