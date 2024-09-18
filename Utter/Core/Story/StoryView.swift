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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Display story title and description
                if let loadedStory = viewModel.story, viewModel.currentChapter == nil {
                    Text(loadedStory.title)
                        .font(.title)
                        .foregroundColor(.blue)
                    Text(loadedStory.description)
                        .font(.body)
                        .foregroundColor(.gray)

                    // Start button to play intro and move to first chapter
                    Button(action: {
                        viewModel.playNextBlock()  // Start the story
                    }) {
                        Text("Start Story")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                } else if let chapter = viewModel.currentChapter {
                    // Display all played blocks in the chapter
                    ForEach(viewModel.playedBlocks) { block in
                        displayBlock(block)
                    }

                    // Button to play the next block
                    if viewModel.getCurrentBlock() != nil {
                        Button(action: {
                            viewModel.playNextBlock()
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
            do {
                try await viewModel.loadStory(path: storageLocation)
            } catch {
                showStoryView = false
            }
        }
        .defaultScrollAnchor(.bottom)
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
