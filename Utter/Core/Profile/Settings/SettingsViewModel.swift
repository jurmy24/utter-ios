//
//  SettingsViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import Foundation


@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws{
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist) // should actually create custom errors
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    // These two functions aren't being used for now!
    func updateEmail(email: String) async throws {
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword(password: String) async throws {
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
}
