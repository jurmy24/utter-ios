//
//  DBStoryModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

struct DBStory: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let chapters: Int
    let difficulty: StoryDifficulty
    let language: Language
    let type: StoryType
    let level: Int
    let dateCreated: Date
    let dateModified: Date?
    let storageLocation: String?
    
    init(
        id: String,
        title: String,
        description: String,
        chapters: Int,
        difficulty: StoryDifficulty,
        language: Language,
        type: StoryType,
        level: Int,
        dateCreated: Date,
        dateModified: Date? = nil,
        storageLocation: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.chapters = chapters
        self.difficulty = difficulty
        self.language = language
        self.type = type
        self.level = level
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.storageLocation = storageLocation
    }
    
    // These are used by the coders
    enum CodingKeys: String, CodingKey {
        case id = "story_id"
        case title = "title"
        case description = "description"
        case chapters = "chapters"
        case difficulty = "difficulty"
        case language = "language"
        case type = "type"
        case level = "level"
        case dateCreated = "date_created"
        case dateModified = "date_modified"
        case storageLocation = "storage_location"
    }
    
    // A decoder that converts the database keys like "user_id" to self.userId
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.chapters = try container.decode(Int.self, forKey: .chapters)
        self.difficulty = try container.decode(StoryDifficulty.self, forKey: .difficulty)
        self.language = try container.decode(Language.self, forKey: .language)
        self.type = try container.decode(StoryType.self, forKey: .type)
        self.level = try container.decode(Int.self, forKey: .level)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.dateModified = try container.decodeIfPresent(Date.self, forKey: .dateModified)
        self.storageLocation = try container.decodeIfPresent(String.self, forKey: .storageLocation)
    }
    
    // An encoder that converts eg self.userId to database keys like "user_id"
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.chapters, forKey: .chapters)
        try container.encode(self.difficulty, forKey: .difficulty)
        try container.encode(self.language, forKey: .language)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.level, forKey: .level)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.dateModified, forKey: .dateModified)
        try container.encodeIfPresent(self.storageLocation, forKey: .storageLocation)
    }
    
    static func ==(lhs: DBStory, rhs: DBStory) -> Bool {
        return lhs.id == rhs.id
    }
}
