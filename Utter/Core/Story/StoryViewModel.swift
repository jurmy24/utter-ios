//
//  StoryViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

@MainActor
final class StoryViewModel: ObservableObject {
    @Published var story: StoryData? = nil       // The entire story loaded from JSON
    @Published var currentChapter: Chapter? = nil  // The current chapter being played
    @Published var playedBlocks: [Block] = []    // Tracks blocks that have been played
    
    private var currentBlockIndex: Int = 0       // Tracks the index of the current block
    
    // Function to load the story from Firebase or other storage
    func loadStory(path: String) async throws {
        let data = try await StorageManager.shared.getStory(path: path)
        self.story = try compileJsonToStory(jsonData: data)
        if let firstChapter = story?.chapters.first {
            self.currentChapter = firstChapter
        }
    }
    
    // Compile the JSON data into a StoryData object
    func compileJsonToStory(jsonData: Data) throws -> StoryData {
        do {
            let story = try JSONDecoder().decode(StoryData.self, from: jsonData)
            return story
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(let key, let context):
                print("Key '\(key.stringValue)' not found: \(context.debugDescription). CodingPath: \(context.codingPath)")
                throw error
            case .typeMismatch(let type, let context):
                print("Type mismatch for type \(type): \(context.debugDescription). CodingPath: \(context.codingPath)")
                throw error
            case .valueNotFound(let type, let context):
                print("Value not found for type \(type): \(context.debugDescription). CodingPath: \(context.codingPath)")
                throw error
            case .dataCorrupted(let context):
                print("Data corrupted: \(context.debugDescription). CodingPath: \(context.codingPath)")
                throw error
            default:
                print("Unknown decoding error: \(error.localizedDescription)")
                throw error
            }
        } catch {
            print("Unknown error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Play the next block in the story
    func playNextBlock() {
        // Ensure there is a current chapter
        guard let currentChapter = currentChapter else { return }
        
        // Check if there is a current block to be played
        if let currentBlock = getCurrentBlock() {
            // Append the current block to played blocks
            playedBlocks.append(currentBlock)
            currentBlockIndex += 1
        } else {
            // Move to the next chapter if there are no more blocks in the current chapter
            moveToNextChapter()
        }
    }
    
    // Get the current block (unplayed)
    func getCurrentBlock() -> Block? {
        // Ensure we have a valid chapter
        guard let currentChapter = currentChapter else { return nil }
        
        // Return the next block that hasn't been played yet
        if currentBlockIndex < currentChapter.blocks.count {
            return currentChapter.blocks[currentBlockIndex]
        } else {
            return nil
        }
    }
    
    // Move to the next chapter if the current one is finished
    private func moveToNextChapter() {
        // Ensure there is a current story and chapter
        guard let story = story, let currentChapter = currentChapter else { return }
        
        // Find the current chapter index
        if let currentChapterIndex = story.chapters.firstIndex(where: { $0.chapter == currentChapter.chapter }) {
            // Check if there is a next chapter
            let nextChapterIndex = currentChapterIndex + 1
            if nextChapterIndex < story.chapters.count {
                // Move to the next chapter
                self.currentChapter = story.chapters[nextChapterIndex]
                self.currentBlockIndex = 0   // Reset block index for the new chapter
                playedBlocks.removeAll()     // Clear played blocks for the new chapter
            }
        }
    }
}

