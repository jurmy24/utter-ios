//
//  StoryBlob.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

@MainActor
final class StoryBlobModel: ObservableObject {
    /* View model to manage Story Blob actions */
    @Published var isBookOpen = false
    @Published var showTooltip = false
}

struct StoryBlob: View {
    let level: Int
    let isLocked: Bool
    let storyTitle: String
    let storyDescription: String
    let numberOfChapters: Int
    var completedChapters: Int
    let size: CGFloat
    
    @StateObject private var storyModel = StoryBlobModel()
    
    // Computed property to check if the story is complete
    var isStoryComplete: Bool {
        numberOfChapters == completedChapters
    }
    
    var body: some View {
        VStack(spacing: size * 0.05) { // Adjust spacing based on size
            ZStack {
                Circle()
                    .fill(isLocked ? Color.gray: Color("StoryIncompleteBackground"))
                    .frame(width: size * 0.82, height: size * 0.82)
                    .overlay(
                        ZStack{
                            Circle()
                                .stroke(Color.white, lineWidth: size * 0.02)
                            Image(systemName: storyModel.isBookOpen ? "book.fill" : "book.closed.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size * 0.45, height: size * 0.45)
                                .foregroundColor(isLocked ? Color.black: (isStoryComplete ? .white.opacity(0.3) : Color("ButtonColor")))
                        }
                        
                    )
                
                // Circular Progress Bar around the Blob
                CircularProgressBarView(
                    total: numberOfChapters,
                    completed: completedChapters,
                    color: Color("ButtonColor"),
                    lineWidth: size * 0.08
                )
                .frame(width: size, height: size)
                .shadow(color: .gray.opacity(0.2), radius: size * 0.05, x: 0, y: size * 0.01)
            }
            
            .onTapGesture {
                withAnimation {
                    // Toggle book opening
                    storyModel.isBookOpen.toggle()
                    // Update showTooltip based on the active ID
                    storyModel.showTooltip.toggle()
                }
            }
            .overlay(
                StoryToolTip(
                    showTooltip: $storyModel.showTooltip,
                    storyTitle: storyTitle,
                    storyDescription: storyDescription,
                    chapters: numberOfChapters,
                    chaptersRead: completedChapters
                )
            )
            
            // Story Title
            Text(storyTitle)
                .font(.system(size: size * 0.1, weight: .bold)) // Font size based on size (10% of total)
                .foregroundColor(isLocked ? Color.gray : .primary)
        }
        .padding(size * 0.1) // Padding proportional to size
    }
}

#Preview {
    StoryBlob(level: 1, isLocked: false, storyTitle: "The Great Adventure", storyDescription: "Some description of this story.", numberOfChapters: 3, completedChapters: 1, size: 200)
}
