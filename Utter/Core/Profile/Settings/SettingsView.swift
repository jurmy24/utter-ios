//
//  SettingsView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-03.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color("AppBackgroundColor")
                .ignoresSafeArea()
            
            List {
                Section {
                    Button(action: signOut) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                        }
                        .foregroundColor(.red)
                    }
                    .listRowBackground(Color("FieldBackground"))
                } header: {
                    Text("Account")
                }
                
                if viewModel.authProviders.contains(.email) {
                    Section {
                        Button(action: resetPassword) {
                            HStack {
                                Image(systemName: "key")
                                Text("Reset Password")
                            }
                        }
                    } header: {
                        Text("Email Functions")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .onAppear {
            viewModel.loadAuthProviders()
        }
    }
    
    private func signOut() {
        Task {
            do {
                try viewModel.signOut()
                showSignInView = true
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }
    
    private func resetPassword() {
        Task {
            do {
                try await viewModel.resetPassword()
                print("Password reset successfully!")
            } catch {
                print("Error resetting password: \(error)")
            }
        }
    }
}
