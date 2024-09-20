//
//  LineViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import Foundation

@MainActor
final class LineViewModel: ObservableObject {
    var story: StoryData? = nil
    var affectedLine: String?
    
    // Using string for the affected line is bad practice, should use a unique identifier or something
    init(story: StoryData?, affectedLine: String?) {
        self.story = story
        self.affectedLine = affectedLine
    }
    
    /// Locate and return the relevant line's text based on the affected line string.
    func getLine() -> Line? {
        guard let story = self.story else {
            print("Story data is nil.")
            return nil
        }

        // Parse the affectedLine into (chapterID, blockID, lineID)
        guard let (chapterID, blockID, lineID) = parseAffectedLine() else {
            print("Line could not be parsed.")
            return nil
        }

        // Find the chapter matching the chapterID
        guard let chapter = story.chapters.first(where: { $0.chapter == chapterID }) else {
            print("Chapter with ID \(chapterID) not found.")
            return nil
        }

        // Find the block matching the blockID within the chapter
        guard let block = chapter.blocks.first(where: { $0.id == blockID }) else {
            print("Block with ID \(blockID) not found in Chapter \(chapterID).")
            return nil
        }

        // Find the line matching the lineID within the block
        guard let line = block.lines?.first(where: { $0.id == lineID }) else {
            print("Line with ID \(lineID) not found in Block \(blockID).")
            return nil
        }

        // Return the line's text
        return line
    }
    
    // Parse affected line format "1-1-2-1" into (chapter, block, line)
    private func parseAffectedLine() -> (Int, Int, Int)? {
        guard let affectedLine = self.affectedLine else {
            return nil
        }
        let components = affectedLine.split(separator: "-").compactMap { Int($0) }
        return (components[1], components[2], components[3])
    }
}
