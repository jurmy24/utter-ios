//
//  LanguageView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct LanguageView: View {
    @State private var selectedLanguage: StoryLanguage = .swedish
    let languages: [StoryLanguage] = [.english, .french, .swedish]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Language options list
            ForEach(languages, id: \.self) { language in
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
        .navigationTitle("Languages")
        .padding()
        .background(Color("AppBackgroundColor")) // Set a background color
        .edgesIgnoringSafeArea(.bottom) // Ensure the background fills the screen
    }
}

#Preview {
    LanguageView()
}

