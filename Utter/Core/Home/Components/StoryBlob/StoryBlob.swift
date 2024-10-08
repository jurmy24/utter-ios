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
    let story: Story
    let size: CGFloat
    
    @StateObject private var storyModel = StoryBlobModel()
    @State private var isShowingPopover = false
    
    var body: some View {
        VStack(spacing: size * 0.05) { // Adjust spacing based on size
            ZStack {
                Circle()
                    .fill(
                        story.isLocked ? Color("LockedLevelBackground"):
                            (story.isComplete ? Color("ButtonColor") :
                                Color("StoryIncompleteBackground")))
                    .frame(width: size * 0.82, height: size * 0.82)
                    .overlay(
                        ZStack{
                            Circle()
                                .stroke(Color.white, lineWidth: size * 0.02)
                            Image(systemName: self.isShowingPopover ? "book.fill" : "book.closed.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size * 0.45, height: size * 0.45)
                                .foregroundColor(story.isLocked ? Color.gray: (story.isComplete ? .white.opacity(0.8) : Color("ButtonColor")))
                        }
                        
                    )
                
                // Circular Progress Bar around the Blob
                CircularProgressBarView(
                    total: story.story.chapters,
                    completed: story.currentChapter - 1,
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
//                    storyModel.showTooltip.toggle()
                    self.isShowingPopover.toggle()
                }
            }
            .popover(
                isPresented: $isShowingPopover, arrowEdge: .top
            ) {
                StoryPopover(
                    story: story
                )
            }
            
            // Story Title
            Text(story.story.title)
                .font(.system(size: size * 0.1, weight: .bold)) // Font size based on size (10% of total)
                .foregroundColor(story.isLocked ? Color.gray : Color("AccentColor"))
                .frame(width:size)
                .lineLimit(nil) // Allow unlimited lines
                .fixedSize(horizontal: false, vertical: true) // Prevents truncation
        }
        .padding(size * 0.1) // Padding proportional to size
    }
}

//#Preview {
//    StoryBlob(story: Story.sample3, size: 150)
//}
