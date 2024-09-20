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
    let type: ExerciseType
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

enum ExerciseType: String, Codable {
    case compMCQ = "comp-mcq"
    case compTF = "comp-tf"
    case compListen = "comp-listen"
    case pronounceRep = "pronounce-rep"
    case pronounceDeaf = "pronounce-deaf"
    case speakReplace = "speak-replace"
    case speakQuestion = "speak-question"
    case interact = "interact"
    
    // Computed property for user-friendly display names
    var displayName: String {
        switch self {
        case .compMCQ:
            return "Multiple Choice Question"
        case .compTF:
            return "True/False Question"
        case .compListen:
            return "Listening Comprehension"
        case .pronounceRep:
            return "Pronunciation: Repeat"
        case .pronounceDeaf:
            return "Pronunciation: Deaf Mode"
        case .speakReplace:
            return "Speaking: Replace Text"
        case .speakQuestion:
            return "Speaking: Question"
        case .interact:
            return "Interactive Exercise"
        }
    }
}

extension ExerciseOption {
    // Sample Multiple Choice Question (MCQ) Exercise
    static let sampleMCQ = ExerciseOption(
        id: 1,
        type: .compMCQ,
        cefr: [.a1, .a2],
        query: "What is the capital of France?",
        answerOptions: [
            "1": AnswerOption(text: "Berlin", isCorrect: false),
            "2": AnswerOption(text: "Madrid", isCorrect: false),
            "3": AnswerOption(text: "Paris", isCorrect: true)
        ],
        hints: ["It's known as the city of lights."],
        audio: nil,
        action: .hideText,
        affectedLine: nil,
        correctAnswer: "3"
    )
    
    // Sample True/False (TF) Exercise
    static let sampleTF = ExerciseOption(
        id: 2,
        type: .compTF,
        cefr: [.a1],
        query: "The Eiffel Tower is located in Berlin. True or False?",
        answerOptions: [
            "1": AnswerOption(text: "True", isCorrect: false),
            "2": AnswerOption(text: "False", isCorrect: true)
        ],
        hints: nil,
        audio: nil,
        action: nil,
        affectedLine: nil,
        correctAnswer: "2"
    )
    
    // Sample Listening Comprehension Exercise
    static let sampleCompListen = ExerciseOption(
        id: 3,
        type: .compListen,
        cefr: [.b1],
        query: nil,
        answerOptions: [
            "1": AnswerOption(text: "She is going to the market.", isCorrect: true),
            "2": AnswerOption(text: "She is going to the park.", isCorrect: false)
        ],
        hints: nil,
        audio: "audiofile.mp3", // Placeholder audio file
        action: .hideAll,
        affectedLine: "1-1-2",
        correctAnswer: "1"
    )
    
    // Sample Pronunciation (Repetition) Exercise
    static let samplePronounceRep = ExerciseOption(
        id: 4,
        type: .pronounceRep,
        cefr: [.b2],
        query: "Repeat after the speaker.",
        answerOptions: nil,
        hints: nil,
        audio: "audiofile.mp3",
        action: .emphasizeText,
        affectedLine: "1-1-1",
        correctAnswer: nil
    )
    
    // Sample Pronunciation (Deaf Mode) Exercise
    static let samplePronounceDeaf = ExerciseOption(
        id: 5,
        type: .pronounceDeaf,
        cefr: [.b2, .c1],
        query: "Pronounce this sentence without listening to it first.",
        answerOptions: nil,
        hints: nil,
        audio: nil,
        action: .hideAudio,
        affectedLine: "1-1-1",
        correctAnswer: nil
    )
    
    // Sample Speak Replace Exercise
    static let sampleSpeakReplace = ExerciseOption(
        id: 6,
        type: .speakReplace,
        cefr: [.b2, .c1],
        query: "Replace the underlined word with your own.",
        answerOptions: nil,
        hints: ["Try using synonyms."],
        audio: nil,
        action: .hideAll,
        affectedLine: "1-1-2",
        correctAnswer: nil
    )
    
    // Sample Speak Question Exercise
    static let sampleSpeakQuestion = ExerciseOption(
        id: 7,
        type: .speakQuestion,
        cefr: [.b2, .c2],
        query: "Answer the following question: What would you do in this situation?",
        answerOptions: nil,
        hints: ["Think about your personal experience."],
        audio: nil,
        action: nil,
        affectedLine: nil,
        correctAnswer: nil
    )
    
    // Sample Interact Exercise
    static let sampleInteract = ExerciseOption(
        id: 8,
        type: .interact,
        cefr: [.c1, .c2],
        query: "Interact with the conversation and give a response.",
        answerOptions: nil,
        hints: ["Consider the context of the conversation."],
        audio: nil,
        action: nil,
        affectedLine: nil,
        correctAnswer: nil
    )
    
    // Collection of all exercise samples
    static let samples = [
        sampleMCQ, sampleTF, sampleCompListen, samplePronounceRep,
        samplePronounceDeaf, sampleSpeakReplace, sampleSpeakQuestion, sampleInteract
    ]
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
