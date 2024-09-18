//
//  StoryLanguageModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

enum Language: String, Codable {
    case english = "en"
    case swedish = "se"
    case french = "fr"
    
    // Function to return the display name and flag for each language
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .swedish:
            return "Swedish"
        case .french:
            return "French"
        }
    }
    
    var flag: String {
        switch self {
        case .english:
            return "🇬🇧"
        case .swedish:
            return "🇸🇪"
        case .french:
            return "🇫🇷"
        }
    }
}
