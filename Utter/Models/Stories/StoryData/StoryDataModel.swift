//
//  StoryDataModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

struct StoryData: Codable {
    let title, description, audio: String
    let voiceMap: [String: String]?
    let language: String
    let storyID: Int
    let difficulty: String
    let chapters: [Chapter]

    enum CodingKeys: String, CodingKey {
        case title, description, audio
        case voiceMap = "voice_map"
        case language
        case storyID = "story_id"
        case difficulty, chapters
    }
}

struct Chapter: Codable {
    let chapter: Int
    let title, summary, audio: String
    let blocks: [Block]
}

struct Block: Identifiable, Codable {
    let id: Int
    let blockType: BlockType
    let lines: [Line]?
    let exerciseOptions: [ExerciseOption]?

    enum CodingKeys: String, CodingKey {
        case id = "block_id"
        case blockType = "block_type"
        case lines
        case exerciseOptions = "exercise_options"
    }
}

enum BlockType: String, Codable {
    case exercise = "exercise"
    case story = "story"
}

struct ExerciseOption: Identifiable, Codable {
    let id: Int
    let type: String
    let cefr: [CEFRLevel]
    let query: String?
    let answerOptions: [String: AnswerOption]?
    let hints: [String]?
    let audio: String?
    let action: Action?
    let affectedLine: String?
    let correctAnswer: String?

    enum CodingKeys: String, CodingKey {
        case id = "exercise_id"
        case type, cefr
        case query
        case answerOptions = "answer_options"
        case hints, audio, action
        case affectedLine = "affected_line"
        case correctAnswer = "correct_answer"
    }
}

enum Action: String, Codable {
    case emphasizeText = "emphasize-text"
    case hideAll = "hide-all"
    case hideAudio = "hide-audio"
    case hideText = "hide-text"
}

struct AnswerOption: Codable {
    let text: String
    let isCorrect: Bool

    enum CodingKeys: String, CodingKey {
        case text
        case isCorrect = "is_correct"
    }
}

//enum Cefr: String, Codable {
//    case a1 = "A1"
//    case a2 = "A2"
//    case b1 = "B1"
//    case b2 = "B2"
//    case c1 = "C1"
//    case c2 = "C2"
//}


struct Line: Identifiable, Codable {
    let id: Int
    let character: Character
    let text, audio: String

    enum CodingKeys: String, CodingKey {
        case id = "line_id"
        case character, text, audio
    }
}

enum Character: String, Codable {
    case anna = "Anna"
    case karl = "Karl"
    case narrator = "Narrator"
}


//struct VoiceMap: Codable {
//    let narrator, anna, karl: String
//
//    enum CodingKeys: String, CodingKey {
//        case narrator = "Narrator"
//        case anna = "Anna"
//        case karl = "Karl"
//    }
//}

//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//    }
//
//    public var hashValue: Int {
//            return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//    }
//}


//
//struct StoryData: Codable {
//    let title: String
//    let description: String
//    let audio: String?
//    let voiceMap: [String: String]?
//    let language: String
//    let storyId: Int
//    let difficulty: String
//    let chapters: [Chapter]
//    
//    enum CodingKeys: String, CodingKey {
//        case title
//        case description
//        case audio
//        case voiceMap = "voice_map"  // Adjusting snake_case to camelCase
//        case language
//        case storyId = "story_id"     // Adjusting snake_case to camelCase
//        case difficulty
//        case chapters
//    }
//}
//
//
//struct Chapter: Codable, Identifiable {
//    let id: Int
//    let title: String
//    let summary: String
//    let audio: String?
//    let blocks: [Block]
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "chapter"           // Mapping 'chapter' to 'id'
//        case title
//        case summary
//        case audio
//        case blocks
//    }
//}
//
//
//struct Block: Codable, Identifiable {
//    let id: Int
//    let type: String
//    let lines: [StoryLine]?
//    let exerciseOptions: [Exercise]?
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "block_id"          // Mapping 'block_id' to 'id'
//        case type = "block_type"      // Mapping 'block_type' to 'type'
//        case lines
//        case exerciseOptions = "exercise_options"
//    }
//}
//
//struct StoryLine: Codable {
//    let lineID: Int
//    let character: String
//    let text: String
//    let audio: String?
//
//    enum CodingKeys: String, CodingKey {
//        case lineID = "line_id"
//        case character
//        case text
//        case audio
//    }
//}
//
//struct Exercise: Codable {
//    let exerciseID: Int
//    let type: ExerciseType
//    let cefr: [CEFRLevel2]
//    let skipCondition: SkipCondition?
//    let query: String?
//    let answerOptions: [String: AnswerOption]?
//    let hints: [String]?
//    let audio: String?
//    let action: Action?
//    let affectedLine: String?
//
//    enum CodingKeys: String, CodingKey {
//        case exerciseID = "exercise_id"
//        case type
//        case cefr
//        case skipCondition = "skip_condition"
//        case query
//        case answerOptions = "answer_options"
//        case hints
//        case audio
//        case action
//        case affectedLine = "affected_line"
//    }
//}
//
//
//enum ExerciseType: String, Codable {
//    case compMCQ = "comp-mcq"
//    case compTF = "comp-tf"
//    case compListen = "comp-listen"
//    case pronounceRep = "pronounce-rep"
//    case pronounceDeaf = "pronounce-deaf"
//    case speakReplace = "speak-replace"
//    case speakQuestion = "speak-question"
//    case interact = "interact"
//}
//
//enum CEFRLevel2: String, Codable {
//    case a1 = "A1"
//    case a2 = "A2"
//    case b1 = "B1"
//    case b2 = "B2"
//    case c1 = "C1"
//    case c2 = "C2"
//}
//
//enum SkipCondition: String, Codable {
//    case ifNotVoice = "if-not-voice"
//    case ifNotAudio = "if-not-audio"
//}
//
//struct AnswerOption: Codable {
//    let text: String
//    let isCorrect: Bool
//}
//
//enum Action: String, Codable {
//    case hideText = "hide-text"
//    case hideAudio = "hide-audio"
//    case emphasizeText = "emphasize-text"
//    case hideAll = "hide-all"
//}
