//
//  StoryBlob.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

struct StoryBlob: View {
    let level: Int
    let isLocked: Bool
    let storyTitle: String
    let numberOfChapters: Int
    var completedChapters: Int
    let size: CGFloat // This determines the overall size of the blob
    
    @State private var isBookOpen = false // State to track if the book is open or closed
    
    // Computed property to check if the story is complete
    var isStoryComplete: Bool {
        numberOfChapters == completedChapters
    }
    
    var body: some View {
        VStack(spacing: size * 0.05) { // Adjust spacing based on size
            ZStack {
                // Circular Progress Bar around the Blob
                CircularProgressBarView(
                    total: numberOfChapters,
                    completed: completedChapters,
                    color: Color("ButtonColor"),
                    lineWidth: size * 0.08 // Line width based on size (e.g., 8% of the size)
                )
                .frame(width: size, height: size) // Overall size of the progress bar
                
                // Blob Circle
                Circle()
                    .fill(isLocked ? Color.gray: Color("StoryIncompleteBackground"))
                    .frame(width: size * 0.85, height: size * 0.85) // Blob size (85% of total size)
                    .shadow(color: .gray.opacity(0.5), radius: size * 0.1, x: 0, y: size * 0.02) // Shadow based on size
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: size * 0.02) // Stroke width proportional to size
                    )
                    .overlay(
                        Image(systemName: isBookOpen ? "book.fill" : "book.closed.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: size * 0.45, height: size * 0.45) // Icon size based on size (45% of total)
                            .foregroundColor(isLocked ? Color.black: (isStoryComplete ? .white.opacity(0.3) : Color("ButtonColor")))
                    )
                    .onTapGesture {
                        withAnimation {
                            isBookOpen.toggle()
                        }
                    }
            }
            
            // Story Title Below the Circle
            Text(storyTitle)
                .font(.system(size: size * 0.1, weight: .bold)) // Font size based on size (10% of total)
                .foregroundColor(isLocked ? Color.gray : .primary)
        }
        .padding(size * 0.1) // Padding proportional to size
    }
}

#Preview {
    StoryBlob(level: 1, isLocked: true, storyTitle: "The Great Adventure", numberOfChapters: 3, completedChapters: 0, size: 200)
}
