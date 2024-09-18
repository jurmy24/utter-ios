//
//  StoryModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

//struct StoryWithProgress: Identifiable {
//    let id: String
//    let story: DBStory
//    let isLocked: Bool
//    let isComplete: Bool
//    let currentChapter: Int
//}

struct Story: Identifiable {
    let id: String
    let story: DBStory
    let userProgress: UserStoryProgress?
    let isLocked: Bool  // Include isLocked in the initializer

    // Computed properties to expose combined data, making it easier to access key information
    var title: String {
        story.title
    }

    var description: String {
        story.description
    }

    var isComplete: Bool {
        userProgress?.isComplete ?? false
    }

    var currentChapter: Int {
        userProgress?.chapter ?? 0
    }
}

extension Story {
    /// Creates a `Story` from a `DBStory` and an optional `UserStoryProgress`.
    ///
    /// - Parameters:
    ///   - story: The `DBStory` instance.
    ///   - userProgress: An optional `UserStoryProgress` instance.
    ///   - isLocked: A `Bool` indicating whether the story is locked.
    /// - Returns: A `Story` instance.
    static func create(from story: DBStory, userProgress: UserStoryProgress?, isLocked: Bool) -> Story {
        return Story(
            id: story.id,
            story: story,
            userProgress: userProgress,
            isLocked: isLocked
        )
    }
}
