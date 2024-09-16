//
//  LevelManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import Foundation

struct StoryWithProgress: Identifiable {
    let id: String
    let story: DBStory
    let isLocked: Bool
    let isComplete: Bool
    let currentChapter: Int
}

final class LevelManager {
    
    static let shared = LevelManager()
    private init() { }
    
    // Merge DBStory and UserStory into StoryWithProgress
    func mergeStoriesWithProgress(dbStories: [DBStory], userStories: [UserStory]) -> [StoryWithProgress] {
        // Create a lookup dictionary for user stories
        let userStoriesDict = Dictionary(uniqueKeysWithValues: userStories.map { ($0.storyId, $0) })
        var result: [StoryWithProgress] = []
        var shouldUnlockNextStory = true

        // Sort stories by level
        let sortedStories = dbStories.sorted(by: { $0.level < $1.level })

        for story in sortedStories {
            if let userStory = userStoriesDict[story.id] {
                // User has progress on this story
                let isComplete = userStory.isComplete
                let isLocked = false
                let currentChapter = userStory.chapter
                result.append(StoryWithProgress(id: story.id, story: story, isLocked: isLocked, isComplete: isComplete, currentChapter: currentChapter))
                shouldUnlockNextStory = isComplete // Unlock next story if current is complete
            } else {
                // User hasn't started this story
                let isLocked = !shouldUnlockNextStory
                result.append(StoryWithProgress(id: story.id, story: story, isLocked: isLocked, isComplete: false, currentChapter: 0))
                shouldUnlockNextStory = false
            }
        }
        return result
    }
}

