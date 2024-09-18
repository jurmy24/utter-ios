//
//  UserLanguageModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

struct UserLanguage: Codable {
    let id: String
    let language: StoryLanguage
    let currentCefr: CEFRLevel
    let startingDifficulty: Difficulty
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case language = "language"
        case currentCefr = "current_cefr"
        case startingDifficulty = "starting_difficulty"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.language = try container.decode(StoryLanguage.self, forKey: .language)
        self.currentCefr = try container.decode(CEFRLevel.self, forKey: .currentCefr)
        self.startingDifficulty = try container.decode(Difficulty.self, forKey: .startingDifficulty)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.language, forKey: .language)
        try container.encode(self.currentCefr, forKey: .currentCefr)
        try container.encode(self.startingDifficulty, forKey: .startingDifficulty)
    }
}
