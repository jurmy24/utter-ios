//
//  LanguageView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

@MainActor
final class LanguageViewModel: ObservableObject {
    
    @Published private(set) var userLanguages: [StoryLanguage] = []
    @Published private(set) var otherLanguages: [StoryLanguage] = [.english, .french, .swedish]
    
    func getUserLanguages() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let userLanguagesProgress = try await UserManager.shared.getUserLanguages(userId: authDataResult.uid)
            
            // Reset userLanguages before appending new data
            self.userLanguages = []
            
            for languageProgress in userLanguagesProgress {
                let language = languageProgress.language
                userLanguages.append(language)
            }
            
            // Get languages that are in otherLanguages but not in userLanguages
            otherLanguages = otherLanguages.filter { !userLanguages.contains($0) }
        }
    }
    
    func addUserLanguage(language: StoryLanguage) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addNewLanguage(userId: authDataResult.uid, language: language)
        }
    }
}

struct LanguageView: View {
    
    @State private var selectedLanguage: StoryLanguage = .swedish
    @StateObject private var viewModel = LanguageViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Language options list
            ForEach(viewModel.userLanguages, id: \.self) { language in
                LanguageOption(
                    language: language,
                    isSelected: selectedLanguage == language // Pass the selected state
                )
                .onTapGesture {
                    // Update selected language
                    selectedLanguage = language
                }
            }
            
            Spacer() // Push content up for a more balanced layout
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    // Add your language options here
                    ForEach(viewModel.otherLanguages, id: \.self) { language in
                        Button(action: {
                            viewModel.addUserLanguage(language: language)
                            viewModel.getUserLanguages()
                        }) {
                            Label(language.displayName, systemImage: "flag.fill")
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("My Languages")
        .padding()
        .background(Color("AppBackgroundColor")) // Set a background color
        .edgesIgnoringSafeArea(.bottom) // Ensure the background fills the screen
        .onAppear {
            viewModel.getUserLanguages()
        }
    }
}

#Preview {
    NavigationStack {
        LanguageView()
    }
    
}

