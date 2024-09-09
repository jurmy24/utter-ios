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
    
    @Published var didSignInWithApple: Bool = false
    let signInAppleHelper = SignInAppleHelper()
    
    
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
    
    var body: some View {
        VStack{
            
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
        .navigationTitle("Sign In")
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
                SignInWithAppleButtonViewRepresentable(type: .continue, style: .black)
                    .allowsHitTesting(false)
            })
            .frame(height:55)
        }
    }
}
    
#Preview {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
}
