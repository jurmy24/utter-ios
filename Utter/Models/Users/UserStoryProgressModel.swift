//
//  UserStoryProgressModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

struct UserStoryProgress: Codable {
    let storyId: String
    let isComplete: Bool
    let chapter: Int
    var currentCefr: CEFRLevel? // Optional cefr value

    init(storyId: String, isComplete: Bool, chapter: Int, currentCefr: CEFRLevel? = nil) {
        self.storyId = storyId
        self.isComplete = isComplete
        self.chapter = chapter
        self.currentCefr = currentCefr
    }
    
    enum CodingKeys: String, CodingKey {
        case storyId = "story_id"
        case isComplete = "is_complete"
        case chapter = "chapter"
        case currentCefr = "current_cefr" // Add cefr to the coding keys (if necessary for encoding/decoding)
    }

    // If necessary, update the encode and decode methods
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.storyId = try container.decode(String.self, forKey: .storyId)
        self.isComplete = try container.decode(Bool.self, forKey: .isComplete)
        self.chapter = try container.decode(Int.self, forKey: .chapter)
        self.currentCefr = try? container.decode(CEFRLevel.self, forKey: .currentCefr) // Decode cefr if present
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.storyId, forKey: .storyId)
        try container.encode(self.isComplete, forKey: .isComplete)
        try container.encode(self.chapter, forKey: .chapter)
        try container.encode(self.currentCefr, forKey: .currentCefr) // Encode cefr if available
    }
}
