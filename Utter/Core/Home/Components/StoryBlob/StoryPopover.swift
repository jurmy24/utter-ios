//
//  PopoverTest.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import SwiftUI

struct StoryPopover: View {
    let story: Story
    @State private var showStoryView: Bool = false
    //    let storyTitle: String
    //    let storyDescription: String
    //    let chapters: Int
    //    let chaptersRead: Int
    //    let isLocked: Bool
    //    let isStoryComplete: Bool
    
    var body: some View {
        ZStack {
            if !story.isLocked{
                Color("AccentColor")
                    .scaleEffect(1.5)
            } else {
                Color("LockedLevelBackground")
                    .scaleEffect(1.5)
            }
            
            
            VStack(alignment: .leading, spacing: 10) {
                
                HorizontalProgressBar(chapters: story.story.chapters,
                                      chaptersRead: story.currentChapter,
                                      lineThickness: 10)
                
                Text(story.story.title)
                    .frame(width: 250, alignment: .leading)
                    .font(.headline)
                    .foregroundColor(story.isLocked ? Color.gray: Color("ReverseTextColor"))
                
                Text(story.story.description)
                    .frame(width: 250, alignment: .leading)
                    .font(.callout)
                    .foregroundColor(story.isLocked ? Color.gray: Color("ReverseTextColor"))
                    .lineLimit(nil) // Allow unlimited lines
                    .fixedSize(horizontal: false, vertical: true) // Prevents truncation
                
                if !story.isLocked {
                    if story.isComplete {
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
                            showStoryView = true
                            
                            
                        }) {
                            HStack {
                                Text("Enter Chapter \(story.currentChapter + 1)")
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
            .background(story.isLocked ? Color("LockedLevelBackground"): Color("AccentColor"))
            .fullScreenCover(isPresented: $showStoryView) {
                StoryView(story: story)
            }
        }
    }
}

//#Preview {
//    StoryPopover(
//        storyTitle: "test",
//        storyDescription: "testing",
//        chapters: 3,
//        chaptersRead: 2,
//        isLocked: true,
//        isStoryComplete: false)
//}
