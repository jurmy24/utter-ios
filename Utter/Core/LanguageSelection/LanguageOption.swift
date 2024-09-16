//
//  LanguageOption.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct LanguageOption: View {
    let language: StoryLanguage
    let isSelected: Bool // Determines if this language is selected
    
    var body: some View {
        HStack {
            Text(language.flag) // Display the flag emoji
            Text(language.displayName) // Display the name of the language
                .font(.headline)
                .foregroundColor(isSelected ? Color("ReverseTextColor") : .primary)
            
            Spacer()
            
            // Show a checkmark if this language is selected
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(Color("ReverseTextColor"))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            isSelected ? Color("AccentColor") : .gray.opacity(0.2)
        )
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    LanguageOption(language: .english, isSelected: true)
        .previewLayout(.sizeThatFits)
        .padding()
}
