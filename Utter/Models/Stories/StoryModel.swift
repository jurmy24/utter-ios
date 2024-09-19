//
//  StoryModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

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
    
    var storageLocation: String? {
        story.storageLocation ?? nil
    }
    
    var imageLocation: String? {
        story.imageLocation ?? nil
    }
}

extension Story {
    static func create(from story: DBStory, userProgress: UserStoryProgress?, isLocked: Bool) -> Story {
        return Story(
            id: story.id,
            story: story,
            userProgress: userProgress,
            isLocked: isLocked
        )
    }
}

// Some sample stories
extension Story {
    static let sample1 = Story(
        id: "1",
        story: DBStory(
            id: "1",
            title: "A Magical Morning",
            description: "The man called Otto experiences a day in his life.",
            chapters: 4,
            difficulty: .beginner,
            language: .english,
            type: .basic,
            level: 1,
            dateCreated: Date()
        ),
        userProgress: UserStoryProgress(
            storyId: "1",
            isComplete: false,
            chapter: 2
        ),
        isLocked: false
    )
    
    static let sample2 = Story(
        id: "2",
        story: DBStory(
            id: "2",
            title: "An Evening Adventure",
            description: "A thrilling journey through the city at night.",
            chapters: 3,
            difficulty: .intermediate,
            language: .english,
            type: .basic,
            level: 2,
            dateCreated: Date()
        ),
        userProgress: UserStoryProgress(
            storyId: "2",
            isComplete: true,
            chapter: 3
        ),
        isLocked: false
    )
    
    static let sample3 = Story(
        id: "3",
        story: DBStory(
            id: "3",
            title: "Mysteries of the Forest",
            description: "Uncover the secrets hidden among the trees.",
            chapters: 3,
            difficulty: .advanced,
            language: .english,
            type: .basic,
            level: 3,
            dateCreated: Date()
        ),
        userProgress: nil,
        isLocked: true
    )
    
    static let samples = [sample1, sample2, sample3]
}
