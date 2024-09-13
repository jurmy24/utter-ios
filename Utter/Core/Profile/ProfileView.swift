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
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedAvatar: String = "🐵" // Default avatar
    @State private var userName: String = "John Doe"
    @State private var userEmail: String = "john.doe@example.com"
    
    // List of available avatars
    let avatars: [[String]] = [
        ["🐵", "🐶", "🐱", "🦊"],
        ["🦁", "🦄", "🐨", "🐼"],
        ["🐸", "🐙", "🐷", "🐮"]
    ]
    
    var body: some View {
        VStack(spacing: 20) {
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
                    Text(user.name ?? "User")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    Text(user.email ?? "Email")
                        .font(.system(size: 16))
                        .foregroundColor(Color.purple)
                }
            }
            .padding(.top)
            
            // Choose Your Avatar Label
            Text("Choose Your Avatar")
                .font(.headline)
                .foregroundColor(Color.purple)
                .padding(.top)
            
            // Avatar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 15) {
                ForEach(avatars.flatMap { $0 }, id: \.self) { avatar in
                    Button(action: {
                        selectedAvatar = avatar
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedAvatar == avatar ? Color.purple.opacity(0.2) : Color.purple.opacity(0.1))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedAvatar == avatar ? Color.purple : Color.clear, lineWidth: 2)
                                )
                            
                            Text(avatar)
                                .font(.system(size: 30))
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Sign Out Button
            Button(action: {
                // Handle sign out action
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .task {
            try? await viewModel.loadCurrentUser()
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
        .background(Color("AppBackgroundColor"))
        .edgesIgnoringSafeArea(.all)
    }
    
}

#Preview {
    NavigationStack{
        ProfileView(showSignInView: .constant(false))
    }
    
}
