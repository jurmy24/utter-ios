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
    let isLocked: Bool
    let isStoryComplete: Bool
    
    var body: some View {
        ZStack {
            if !isLocked{
                Color("AccentColor")
                    .scaleEffect(1.5)
            } else {
                Color("LockedLevelBackground")
                    .scaleEffect(1.5)
            }
            
            
            VStack(alignment: .leading, spacing: 10) {
                
                HorizontalProgressBar(chapters: chapters,
                                      chaptersRead: chaptersRead,
                                      lineThickness: 10)
                
                Text(storyTitle)
                    .frame(width: 250, alignment: .leading)
                    .font(.headline)
                    .foregroundColor(isLocked ? Color.gray: Color("ReverseTextColor"))
                
                Text(storyDescription)
                    .frame(width: 250, alignment: .leading)
                    .font(.callout)
                    .foregroundColor(isLocked ? Color.gray: Color("ReverseTextColor"))
                    .lineLimit(nil) // Allow unlimited lines
                    .fixedSize(horizontal: false, vertical: true) // Prevents truncation
                
                if !isLocked {
                    if isStoryComplete {
                        Button(action: {
                            // Button action
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Redo!")
                                    .font(.headline)
                            }
                            .frame(height: 44)
                            .padding(.horizontal)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                        }
                    } else {
                        Button(action: {
                            // TODO: open the story view and print the storageLocation (for now)
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
            }
            .presentationCompactAdaptation(.popover)
            .padding()
            .background(isLocked ? Color("LockedLevelBackground"): Color("AccentColor"))
        }
    }
}

#Preview {
    StoryPopover(
        storyTitle: "test",
        storyDescription: "testing",
        chapters: 3,
        chaptersRead: 2,
        isLocked: true,
        isStoryComplete: false)
}
