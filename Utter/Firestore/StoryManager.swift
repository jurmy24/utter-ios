//
//  StoryManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-15.
//

import Foundation
import FirebaseFirestore

enum Difficulty: String, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
}

enum StoryLanguage: String, Codable {
    case english = "en"
    case swedish = "se"
    case french = "fr"
}

enum StoryType: String, Codable {
    case basic = "basic"
    case branching = "branching"
    case podcast = "podcast"
}

struct DBStory: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let chapters: Int
    let difficulty: Difficulty
    let language: StoryLanguage
    let type: StoryType
    let level: Int
    let dateCreated: Date
    let dateModified: Date?
    
    init(
        id: String,
        title: String,
        description: String,
        chapters: Int,
        difficulty: Difficulty,
        language: StoryLanguage,
        type: StoryType,
        level: Int,
        dateCreated: Date,
        dateModified: Date? = nil
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
    }
    
    // A decoder that converts the database keys like "user_id" to self.userId
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.chapters = try container.decode(Int.self, forKey: .chapters)
        self.difficulty = try container.decode(Difficulty.self, forKey: .difficulty)
        self.language = try container.decode(StoryLanguage.self, forKey: .language)
        self.type = try container.decode(StoryType.self, forKey: .type)
        self.level = try container.decode(Int.self, forKey: .level)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.dateModified = try container.decodeIfPresent(Date.self, forKey: .dateModified)
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
    }
    
    static func ==(lhs: DBStory, rhs: DBStory) -> Bool {
        return lhs.id == rhs.id
    }
}

final class StoryManager {
    
    static let shared = StoryManager()
    private init() { }
    
    private let storyCollection = Firestore.firestore().collection("stories")
    
    private func storyDocument(storyId: String) -> DocumentReference {
        storyCollection.document(storyId)
    }
    
    func uploadStory(story: DBStory) async throws {
        try storyDocument(storyId: String(story.id)).setData(from: story, merge: false)
    }
    
    func getStory(storyId: String) async throws -> DBStory {
        try await storyDocument(storyId: storyId).getDocument(as: DBStory.self)
    }
    
    func getAllStories() async throws -> [DBStory] {
        try await storyCollection.getDocuments(as: DBStory.self)
    }
    
//    func getAllStoriesSortedByLevel() async throws -> [DBStory] {
//        try await storyCollection.order(by: DBStory.CodingKeys.level.rawValue, descending: false).getDocuments(as: DBStory.self)
//    }
//    
//    func getAllStoriesForLanguage(language: StoryLanguage) async throws -> [DBStory] {
//        try await storyCollection.whereField(DBStory.CodingKeys.language.rawValue, isEqualTo: language.rawValue).getDocuments(as: DBStory.self)
//    }
    
    func getAllStoriesByLanguage(language: StoryLanguage) async throws -> [DBStory] {
        try await storyCollection
            .whereField(DBStory.CodingKeys.language.rawValue, isEqualTo: language.rawValue)
            .order(by: DBStory.CodingKeys.level.rawValue, descending: false)
            .getDocuments(as: DBStory.self)
    }
}

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ document in
            return try document.data(as: T.self)
        })
    }
}
