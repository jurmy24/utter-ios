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
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found!")
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
    var body: some View {
        VStack{
            TextField("Email...", text:$viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(8)
            
            SecureField("Password...", text:$viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(8)
            
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
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up With Email")
    }
}

#Preview {
    NavigationStack{
        SignUpEmailView(showSignInView: .constant(false))
    }
    
}
