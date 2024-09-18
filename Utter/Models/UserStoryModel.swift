//
//  UserStoryModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

struct UserStory: Codable {
    let storyId: String
    let isComplete: Bool
    let chapter: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case storyId = "story_id"
        case isComplete = "is_complete"
        case chapter = "chapter"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.storyId = try container.decode(String.self, forKey: .storyId)
        self.isComplete = try container.decode(Bool.self, forKey: .isComplete)
        self.chapter = try container.decode(Int.self, forKey: .chapter)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.storyId, forKey: .storyId)
        try container.encode(self.isComplete, forKey: .isComplete)
        try container.encode(self.chapter, forKey: .chapter)
    }
}
