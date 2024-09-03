//
//  AuthenticationView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-03.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack{
            NavigationLink{
                SignInEmailView()
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign in")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView()
    }
}
