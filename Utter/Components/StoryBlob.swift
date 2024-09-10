//
//  StoryBlob.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

struct StoryBlob: View {
    var storyTitle: String
    var numberOfChapters: Int
    var completedChapters: Int
    
    @State private var isBookOpen = false // State to track if the book is open or closed
    
    // Computed property to check if the story is complete
    var isStoryComplete: Bool {
        numberOfChapters == completedChapters
    }
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                // Circular Progress Bar around the Blob
                CircularProgressBarView(
                    total: numberOfChapters,
                    completed: completedChapters,
                    color: Color("ButtonColor"),
                    lineWidth: 15 // Adjust the width of the progress bar
                )
                .frame(width: 180, height: 180) // Adjust size to wrap around the circle
                
                if !isStoryComplete{
                    // Circular Blob with Gradient Background
                    Circle()
                        .fill(Color("StoryIncompleteBackground"))
                        .frame(width: 150, height: 150)
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .overlay(
                            Image(systemName: isBookOpen ? "book.fill" : "book.closed.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color("ButtonColor"))
                        )
                        .onTapGesture {
                            withAnimation {
                                isBookOpen.toggle()
                            }
                        }
                } else {
                    // Circular Blob with Gradient Background
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                                             startPoint: .top, endPoint: .bottom))
                        .frame(width: 150, height: 150)
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .overlay(
                            Image(systemName: isBookOpen ? "book.fill" : "book.closed.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.white.opacity(0.3))
                        )
                        .onTapGesture {
                            withAnimation {
                                isBookOpen.toggle()
                            }
                        }
                }
            }
            
            // Story Title Below the Circle
            Text(storyTitle)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
    }
}

#Preview {
    StoryBlob(storyTitle: "The Great Adventure", numberOfChapters: 3, completedChapters: 2)
}
