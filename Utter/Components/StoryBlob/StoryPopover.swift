//
//  PopoverTest.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import SwiftUI

struct StoryPopover: View {
    let storyTitle: String
    let storyDescription: String
    let chapters: Int
    let chaptersRead: Int
    
    
    var body: some View {
        ZStack {
            Color("AccentColor")
                .scaleEffect(1.5)
            
            VStack(alignment: .leading, spacing: 10) {
                
                HorizontalProgressBar(chapters: chapters, 
                                      chaptersRead: chaptersRead,
                                      lineThickness: 10)
                
                Text(storyTitle)
                    .frame(width: 250, alignment: .leading)
                    .font(.headline)
                    .foregroundColor(Color("ReverseTextColor"))
                
                Text(storyDescription)
                    .frame(width: 250, alignment: .leading)
                    .font(.callout)
                    .foregroundColor(Color("ReverseTextColor"))
                
                Button(action: {
                    // Button action
                }) {
                    HStack {
                        Text("Enter Chapter \(chaptersRead + 1)")
                            .font(.headline)
                        Image(systemName: "chevron.right")
                    }
                    .frame(height: 44)
                    .padding(.horizontal)
                    .background(Color("ButtonColor"))
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                }
            }
        }
        .presentationCompactAdaptation(.popover)
        .padding()
        .background(Color.accentColor)
    }
}

#Preview {
    StoryPopover(
        storyTitle: "test",
        storyDescription: "testing",
        chapters: 3,
        chaptersRead: 2)
}
