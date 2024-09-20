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
    @Published var chapterComplete: Bool = false
        
    let chapterId: Int
    let userLevel: CEFRLevel
    let storyMetadata: Story?
    
    init(chapterId: Int, userLevel: CEFRLevel, storyMetadata: Story?) {
        self.chapterId = chapterId
        self.userLevel = userLevel
        self.storyMetadata = storyMetadata
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
    
    private func compileJsonToStory(jsonData: Data) throws -> StoryData {
        do {
            return try JSONDecoder().decode(StoryData.self, from: jsonData)
        } catch {
            print("Error decoding story: \(error)")
            throw error
        }
    }
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
            // TODO: update chapter complete in database, if chapter == numChapters set story to complete and unlock the next story
            Task {
                if let storyMetadata = self.storyMetadata {
                    let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                    do {
                        try await UserManager.shared.updateUserStoryProgress(userId: authDataResult.uid, language: storyMetadata.story.language, storyId: storyMetadata.id, totalChapters: storyMetadata.story.chapters)
                    } catch {
                        print("Didn't work so well")
                    }
                } else {
                    print("Didn't work")
                }
            }
            print("End of chapter")
            chapterComplete = true
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
                
                // Accept any exercise below your CEFR level
                let suitableExercises = exerciseOptions.filter { option in
                    // Allow exercises with CEFR levels less than or equal to the user's level
                    return option.cefr.contains(where: { $0.rank <= userLevel.rank })
                }

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
        return (components[1], components[2], components[3])
    }
}

