//
//  SignUpEmailView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-03.
//

import SwiftUI

@MainActor
final class SignUpEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            print("No email or password found!")
            return
        }
        
        guard password == confirmPassword else {
            print("Passwords don't match!")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
        print("Successfully created a new user!")
        print(returnedUserData)
    }
}

struct SignUpEmailView: View {
    
    @StateObject private var viewModel = SignUpEmailViewModel()
    @Binding var showSignInView: Bool
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack{
            
            Text("Join the Utter community to learn your language with interactive stories!")
                .font(.headline)
                .foregroundColor(.accentColor)
                .padding()
            
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
                    .stroke(Color("ReverseAccent"), lineWidth: 1) // Set the border color and thickness
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
                    .stroke(Color("ReverseAccent"), lineWidth: 1)
            )
            
            // Password field with icon
            HStack {
                if isPasswordVisible {
                    Image(systemName: "lock")
                        .foregroundColor(.accentColor)
                    TextField("Confirm Password", text: $viewModel.confirmPassword)
                        .autocapitalization(.none)
                        .cornerRadius(8)
                } else {
                    Image(systemName: "lock") // Password icon
                        .foregroundColor(.accentColor)
                    // Show SecureField for hidden password
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
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
                    .stroke(Color("ReverseAccent"), lineWidth: 1)
            )
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
                    .background(Color("ButtonColor"))
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Welcome to Utter")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackgroundColor"))
    }
}

#Preview {
    NavigationStack{
        SignUpEmailView(showSignInView: .constant(false))
    }
    
}
