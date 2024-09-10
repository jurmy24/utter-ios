//
//  AuthenticationView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-03.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

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


struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack{
            
            Image(colorScheme == .dark ? "TextLogoDark" : "TextLogoLight")
            
            SignInEmailView(showSignInView: $showSignInView)
            
            NavigationLink{
                SignUpEmailView(showSignInView: $showSignInView)
            } label: {
                
                Text("Don't have an account? Sign up.")
                    .font(.callout)
                    .foregroundColor(Color.blue)
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
            }
            
            LabelledDivider(label: "Or continue with", color: Color.primary)
            ssoOptions
            
            //            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackgroundColor"))
    }
}


extension AuthenticationView {
    
    private var ssoOptions: some View {
        VStack {
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                ContinueWithGoogle()
            })
            
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                SignInWithAppleButtonViewRepresentable(type: .continue, style: .white)
                    .allowsHitTesting(false)
            })
            .frame(height:55)
            .overlay(
                RoundedRectangle(cornerRadius: 8) // Create a rounded rectangle for the border
                    .stroke(Color.black, lineWidth: 1) // Set the border color and thickness
            )
        }
    }
}

#Preview {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
}
