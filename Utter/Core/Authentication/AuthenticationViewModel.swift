//
//  AuthenticationViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import Foundation


@MainActor
final class AuthenticationViewModel: ObservableObject {
    /* View model to manage login button presses */
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    }
}
