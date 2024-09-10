//
//  SignInEmailView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-04.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found!")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        print("Successfully signed in!")
        print(returnedUserData)
        
    }
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack{
            // Email Field with Icon
            HStack {
                Image(systemName: "envelope") // Email icon
                    .foregroundColor(.accentColor)
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            .padding()
            .background(Color("FieldBackground"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8) // Create a rounded rectangle for the border
                    .stroke(Color("FieldBorder"), lineWidth: 1) // Set the border color and thickness
            )
            
            // Password field with icon
            HStack {
                if isPasswordVisible {
                    Image(systemName: "lock")
                        .foregroundColor(.accentColor)
                    TextField("Password", text: $viewModel.password)
                        .autocapitalization(.none)
                        .cornerRadius(8)
                } else {
                    Image(systemName: "lock") // Password icon
                        .foregroundColor(.accentColor)
                    // Show SecureField for hidden password
                    SecureField("Password", text: $viewModel.password)
                        .autocapitalization(.none)
                        .cornerRadius(8)
                }
                
                // Eye icon to toggle password visibility
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                }
                .foregroundColor(.accentColor)
            }
            .padding()
            .background(Color("FieldBackground"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("FieldBorder"), lineWidth: 1)
            )
            
            Button {
                Task {
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
                    .background(Color("ButtonColor"))
                    .cornerRadius(8)
            }
            
        }
    }
}

#Preview {
    SignInEmailView(showSignInView: .constant(false))
}
