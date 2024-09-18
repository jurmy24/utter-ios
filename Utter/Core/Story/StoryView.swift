//
//  StoryView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct StoryView: View {
    let story: Story
    @Binding var showStoryView: Bool
    @StateObject private var viewModel = StoryViewModel()
    @State private var textInfo: String = ""

    var body: some View {
        ScrollView {
            if let loadedStory = viewModel.story {
                VStack(alignment: .leading, spacing: 16) {
                    // Story title
                    Text(loadedStory.title)
                        .font(.title)
                        .foregroundColor(.blue)

                    // Story description
                    Text(loadedStory.description)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)

                    // Next button
                    Button(action: {
                        // Add your next action here (e.g., navigating to the next chapter)
                        print("Next button tapped")
                    }) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            } else {
                Text(textInfo)
                    .foregroundColor(.red)
                    .font(.headline)
            }
        }
        .task {
            // Load the story when the view appears
            guard let storageLocation = story.storageLocation else {
                textInfo = "Storage location not found"
                return
            }
            do {
                try await viewModel.loadStory(path: storageLocation)
                textInfo = ""  // Clear any previous error messages on success
            } catch {
                textInfo = "Unable to load story: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    StoryView(story: Story.sample1, showStoryView: .constant(true))
}
