//
//  StoryViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

@MainActor
final class StoryViewModel: ObservableObject {
    @Published var story: StoryData?
    @Published var currentChapter: Chapter?
    @Published var currentBlock: Block?
    @Published var currentLineIndex: Int = 0
    @Published var lineModifications: [String: Action] = [:] // Store modifications per line
    @Published var selectedExercises: [Int: ExerciseOption] = [:]  // Store selected exercises per block
    @Published var displayedBlocks: [Block] = []
        
    let chapterId: Int
    let userLevel: CEFRLevel
    
    init(chapterId: Int, userLevel: CEFRLevel) {
        self.chapterId = chapterId
        self.userLevel = userLevel
    }
    
    // Computed property for progress
    var progress: Double {
        guard let currentChapter = currentChapter else {
            return 0
        }
        let totalBlocks = currentChapter.blocks.count
        let displayedCount = displayedBlocks.count
        return totalBlocks > 0 ? Double(displayedCount) / Double(totalBlocks) : 0
    }
    
    func loadStory(path: String) async throws {
        let data = try await StorageManager.shared.getStory(path: path)
        self.story = try compileJsonToStory(jsonData: data)
        startChapter()
    }
    
    //    // Function to load the story from Firebase
    //    @discardableResult
    //    func loadStory(path: String) async throws -> StoryData? {
    //        let data = try await StorageManager.shared.getStory(path: path)
    //        self.story = try compileJsonToStory(jsonData: data)
    //        guard let story = self.story else {
    //            throw URLError(.badServerResponse)
    //        }
    //        return story
    //    }
    
    private func compileJsonToStory(jsonData: Data) throws -> StoryData {
        do {
            return try JSONDecoder().decode(StoryData.self, from: jsonData)
        } catch {
            print("Error decoding story: \(error)")
            throw error
        }
    }
    
    //    // Compile the JSON data into a StoryData object
    //    func compileJsonToStory(jsonData: Data) throws -> StoryData {
    //        do {
    //            let story = try JSONDecoder().decode(StoryData.self, from: jsonData)
    //            return story
    //        } catch let error as DecodingError {
    //            switch error {
    //            case .keyNotFound(let key, let context):
    //                print("Key '\(key.stringValue)' not found: \(context.debugDescription). CodingPath: \(context.codingPath)")
    //                throw error
    //            case .typeMismatch(let type, let context):
    //                print("Type mismatch for type \(type): \(context.debugDescription). CodingPath: \(context.codingPath)")
    //                throw error
    //            case .valueNotFound(let type, let context):
    //                print("Value not found for type \(type): \(context.debugDescription). CodingPath: \(context.codingPath)")
    //                throw error
    //            case .dataCorrupted(let context):
    //                print("Data corrupted: \(context.debugDescription). CodingPath: \(context.codingPath)")
    //                throw error
    //            default:
    //                print("Unknown decoding error: \(error.localizedDescription)")
    //                throw error
    //            }
    //        } catch {
    //            print("Unknown error: \(error.localizedDescription)")
    //            throw error
    //        }
    //    }
}

// Handle the display logic
extension StoryViewModel {
    
    // Start by loading the first block of the chapter
    func startChapter() {
        guard let story = story else { return }
        currentChapter = story.chapters.first { $0.chapter == chapterId }
        currentBlock = currentChapter?.blocks.first
        displayedBlocks = [currentBlock].compactMap { $0 }
        preprocessBlocks()
    }
    
    // Move to the next block in the chapter
    func playNextBlock() {
        guard let currentChapter = currentChapter,
              let currentIndex = currentChapter.blocks.firstIndex(where: { $0.id == currentBlock?.id }) else { return }
        
        let nextIndex = currentIndex + 1
        if nextIndex < currentChapter.blocks.count {
            currentBlock = currentChapter.blocks[nextIndex]
            currentLineIndex = 0
        } else {
            // End of chapter logic here
            print("End of chapter")
        }
    }
    
    func playNextLine() {
        guard let currentBlock = currentBlock else { return }
        
        switch currentBlock.blockType {
        case .story:
            let storyBlock = currentBlock
            if currentLineIndex < (storyBlock.lines?.count ?? 0) - 1 {
                currentLineIndex += 1
            } else {
                moveToNextBlock()
            }
        case .exercise:
            moveToNextBlock()
        }
    }
    
    private func moveToNextBlock() {
        guard let currentChapter = currentChapter,
              let currentIndex = currentChapter.blocks.firstIndex(where: { $0.id == currentBlock?.id }) else { return }
        
        let nextIndex = currentIndex + 1
        if nextIndex < currentChapter.blocks.count {
            currentBlock = currentChapter.blocks[nextIndex]
            currentLineIndex = 0
            displayedBlocks.append(currentBlock!)
        } else {
            // End of chapter logic here
            print("End of chapter")
        }
    }
    
    private func preprocessBlocks() {
        guard let blocks = currentChapter?.blocks else { return }
        
        for block in blocks {
            if case .exercise = block.blockType {
                guard let exerciseOptions = block.exerciseOptions else {
                    print("No exercises found in block with id: \(block.id)")
                    return
                }
                
                let suitableExercises = exerciseOptions.filter { $0.cefr.contains(userLevel) }
                if let selectedExercise = suitableExercises.randomElement() {
                    selectedExercises[block.id] = selectedExercise
                    if let affectedLine = selectedExercise.affectedLine, let action = selectedExercise.action {
                        let (_, blockId, lineId) = parseAffectedLine(affectedLine)
                        lineModifications["\(blockId)-\(lineId)"] = action
                    }
                }
            }
        }
    }
    
    // Parse affected line format "1-1-2-1" into (chapter, block, line)
    private func parseAffectedLine(_ affectedLine: String) -> (Int, Int, Int) {
        let components = affectedLine.split(separator: "-").compactMap { Int($0) }
        return (components[0], components[1], components[2])
    }
}

