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
    @Published var activeTooltipID: UUID? = nil // Track the active tooltip by UUID
}


// Main View that tracks active tooltip
struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Pass HomeViewModel to each StoryBlob to track the active tooltip
            StoryBlob(level: 1, isLocked: false, storyTitle: "Zlatan", storyDescription: "Zlatan Ibrahimovic's life and experience.", numberOfChapters: 4, completedChapters: 3, size: 100)
            
            StoryBlob(level: 2, isLocked: false, storyTitle: "Another Story", storyDescription: "Description for another story.", numberOfChapters: 5, completedChapters: 2, size: 100)
            
            StoryBlob(level: 3, isLocked: true, storyTitle: "Locked Story", storyDescription: "This story is locked.", numberOfChapters: 3, completedChapters: 0, size: 100)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackgroundColor"))
    }
}

#Preview {
    HomeView()
}
