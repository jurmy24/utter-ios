//
//  HomeView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    /* View model to manage Home View actions */
    
    @Published var activeTooltip: Int? = nil // Track active tooltip by ID
    
    // Toggle tooltip visibility based on the provided ID
    func toggleTooltip(for id: Int) {
        if activeTooltip == id {
            activeTooltip = nil
        } else {
            activeTooltip = id
        }
    }
}


// Main View that tracks active tooltip
struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 20) {
            // First button
            Button(action: {
                viewModel.toggleTooltip(for: 1)
            }) {
                StoryBlob(level: 1, isLocked: true, storyTitle: "Zlatan", numberOfChapters: 4, completedChapters: 3, size: 100)
            }
            .overlay(
                StoryToolTip(
                    showTooltip: Binding(
                        get: { viewModel.activeTooltip == 1 },  // Show tooltip if activeTooltip is 1
                        set: { if !$0 { viewModel.activeTooltip = nil } }
                    ),
                    storyTitle: "Level 1",
                    storyDescription: "This is the first level.",
                    chapters: 4,
                    chaptersRead: 1
                )
            )

            // Second button
            Button(action: {
                viewModel.toggleTooltip(for: 2)
            }) {
                StoryBlob(level: 1, isLocked: false, storyTitle: "Zlatan", numberOfChapters: 4, completedChapters: 3, size: 100)
            }
            .overlay(
                StoryToolTip(
                    showTooltip: Binding(
                        get: { viewModel.activeTooltip == 2 },  // Show tooltip if activeTooltip is 2
                        set: { if !$0 { viewModel.activeTooltip = nil } }
                    ),
                    storyTitle: "Level 2",
                    storyDescription: "This is the second level.",
                    chapters: 5,
                    chaptersRead: 2
                )
            )
            

            // Third button
            Button(action: {
                viewModel.toggleTooltip(for: 3)
            }) {
                StoryBlob(level: 1, isLocked: true, storyTitle: "Zlatan", numberOfChapters: 4, completedChapters: 3, size: 100)
            }
            .overlay(
                StoryToolTip(
                    showTooltip: Binding(
                        get: { viewModel.activeTooltip == 3 },  // Show tooltip if activeTooltip is 3
                        set: { if !$0 { viewModel.activeTooltip = nil } }
                    ),
                    storyTitle: "Level 3",
                    storyDescription: "This is the third level.",
                    chapters: 6,
                    chaptersRead: 3
                )
            )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackgroundColor"))
    }
}

#Preview {
    HomeView()
}
