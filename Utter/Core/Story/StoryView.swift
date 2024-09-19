//
//  StoryView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct StoryView: View {
    let storyMetadata: Story
    @Binding var showStoryView: Bool
    @StateObject private var viewModel = StoryViewModel()
    @State private var displayTitle = true
    @State private var image: UIImage? = nil
    @State private var story: StoryData?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Display story title and description
                if let loadedStory = viewModel.story, viewModel.currentChapter == nil {
                    
                } else if let chapter = viewModel.currentChapter {
                    // Display all played blocks in the chapter
                    ForEach(viewModel.playedBlocks) { block in
                        displayBlock(block)
                    }

                    // Button to play the next block
                    if viewModel.getCurrentBlock() != nil {
                        StoryButton(text: "Next", color: Color("AccentColor"), action: {
                            viewModel.playNextBlock()
                        })
                    }
                }
            }
            .padding()
        }
        .task {
            // Load the story when the view appears
            guard let storageLocation = storyMetadata.storageLocation else {
                showStoryView = false
                return
            }
            let story = try? await viewModel.loadStory(path: storageLocation)
            self.story = story
        }
        .background(Color("AppBackgroundColor"))
        .defaultScrollAnchor(.bottom)
        .navigationBarBackButtonHidden(true)
    }

    // Display block
    @ViewBuilder
    private func displayBlock(_ block: Block) -> some View {
        if block.blockType == .story, let lines = block.lines {
            displayStoryBlock(lines)
        } else if block.blockType == .exercise, let exercises = block.exerciseOptions {
            displayExerciseBlock(exercises)
        }
    }

    // Display story block
    @ViewBuilder
    private func displayStoryBlock(_ lines: [Line]) -> some View {
        ForEach(lines) { line in
            TextBlob(avatar: "person.circle.fill", character: line.character.rawValue, text: line.text)
        }
    }

    // Display exercise block
    @ViewBuilder
    private func displayExerciseBlock(_ exercises: [ExerciseOption]) -> some View {
        ForEach(exercises) { exercise in
            if let query = exercise.query {
                Text("Exercise: \(query)")
                    .font(.headline)
                    .padding(.vertical, 8)
            }
        }
    }
}

#Preview {
    StoryView(storyMetadata: Story.sample1, showStoryView: .constant(true))
}
