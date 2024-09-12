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

// Main View that tracks active tooltip
struct ContentView: View {
    @State private var activeTooltip: Int? = nil // Track active tooltip by ID
    
    var body: some View {
        VStack(spacing: 20) {
            // First button
            Button(action: {
                toggleTooltip(for: 1)
                
            }) {
                Text("Test")
                //                StoryBlob(level: 1, isLocked: true, storyTitle: "Zlatan", numberOfChapters: 4, completedChapters: 3, size: 100)
            }
            .overlay(
                StoryToolTip(
                    showTooltip: Binding(
                        get: { activeTooltip == 1 },  // Show tooltip if activeTooltip is 1
                        set: { if !$0 { activeTooltip = nil } }
                    ),
                    storyTitle: "Level 1",
                    storyDescription: "This is the first level.",
                    chapters: 4,
                    chaptersRead: 1
                )
            )
            
            // Second button
            Button(action: {
                toggleTooltip(for: 2)
            }) {
                Text("Test 2")
                //                StoryBlob(level: 1, isLocked: false, storyTitle: "Zlatan", numberOfChapters: 4, completedChapters: 3, size: 100)
            }
            .overlay(
                StoryToolTip(
                    showTooltip: Binding(
                        get: { activeTooltip == 2 },  // Show tooltip if activeTooltip is 2
                        set: { if !$0 { activeTooltip = nil } }
                    ),
                    storyTitle: "Level 2",
                    storyDescription: "This is the second level.",
                    chapters: 5,
                    chaptersRead: 2
                )
            )
            
            
            // Third button
            Button(action: {
                toggleTooltip(for: 3)
            }) {
                Text("Test 3")
                //                StoryBlob(level: 1, isLocked: true, storyTitle: "Zlatan", numberOfChapters: 4, completedChapters: 3, size: 100)
            }
            .overlay(
                StoryToolTip(
                    showTooltip: Binding(
                        get: { activeTooltip == 3 },  // Show tooltip if activeTooltip is 3
                        set: { if !$0 { activeTooltip = nil } }
                    ),
                    storyTitle: "Level 3",
                    storyDescription: "This is the third level.",
                    chapters: 6,
                    chaptersRead: 3
                )
            )
        }
        .padding()
    }
    
    // Toggle tooltip visibility based on the provided ID
    private func toggleTooltip(for id: Int) {
        if activeTooltip == id {
            activeTooltip = nil // Close if it's the currently active one
        } else {
            activeTooltip = id // Open the tooltip for the clicked button
        }
    }
}

#Preview {
    ContentView()
}
