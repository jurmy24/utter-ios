//
//  AvatarGrid.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct AvatarGrid: View {
    
    @Binding var selectedAvatar: String
    
    // List of available avatars
    private let avatars: [[String]] = [
        ["🐵", "🐶", "🐱", "🦊"],
        ["🦁", "🦄", "🐨", "🐼"],
        ["🐸", "🐙", "🐷", "🐮"]
    ]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 15) {
            ForEach(avatars.flatMap { $0 }, id: \.self) { avatar in
                Button(action: {
                    selectedAvatar = avatar
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedAvatar == avatar ? Color.purple.opacity(0.2) : Color.purple.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedAvatar == avatar ? Color("ReverseAccent") : Color.clear, lineWidth: 2)
                            )
                        
                        Text(avatar)
                            .font(.system(size: 30))
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    AvatarGrid(selectedAvatar: .constant("🐵"))
}
