//
//  ProfileViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-17.
//

import Foundation

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
