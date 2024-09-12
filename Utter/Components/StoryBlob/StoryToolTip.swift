//
//  StoryToolTip.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-11.
//

import SwiftUI

// StoryToolTip that Accepts Custom Content
struct StoryToolTip: View {
    @Binding var showTooltip: Bool
    let storyTitle: String
    let storyDescription: String
    let chapters: Int
    let chaptersRead: Int
    
    var body: some View {
        ToolTip(
            alignment: .top,
            isVisible: $showTooltip,
            backgroundColor: Color("AccentColor")
        ) {
            VStack(alignment: .leading, spacing: 10) {
                
                // Horizontal progress bar with customizable data
                HorizontalProgressBar(chapters: chapters, chaptersRead: chaptersRead, lineThickness: 10, color: Color("AppBackgroundColor"))
                
                // Story title and description
                Text(storyTitle)
                    .frame(width: 250, alignment: .leading)
                    .font(.headline)
                    .foregroundColor(Color.white)
                
                Text(storyDescription)
                    .frame(width: 250, alignment: .leading)
                    .font(.callout)
                    .foregroundColor(Color.white)
                
                
                // Button with custom action
                Button(action: {
                    // Button action
                }) {
                    HStack {
                        Text("Start Chapter \(chaptersRead + 1)")
                            .font(.headline)
                        Image(systemName: "chevron.right")
                    }
                    .frame(width: 180, height: 44)
                    .background(Color("ButtonColor"))
                    .cornerRadius(5)
                }
            }
        }
    }
}

#Preview {
    StoryToolTip(showTooltip: .constant(true), storyTitle: "The Title", storyDescription: "A slightly longer description", chapters: 3, chaptersRead: 2)
}
