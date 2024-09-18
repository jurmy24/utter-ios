//
//  StoryViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

@MainActor
final class StoryViewModel: ObservableObject {
    
    @Published var storyString: String = ""
    @Published var story: StoryData? = nil
    
    func loadStory(path: String) async throws {
        let data = try await StorageManager.shared.getStory(path: path)
//        self.storyString = String(data: data, encoding: .utf8) ?? "nah mate"
//        print(self.storyString)
        self.story = try compileJsonToStory(jsonData: data)
    }
    
    // Function to compile JSON data into StoryData
    func compileJsonToStory(jsonData: Data) throws -> StoryData {
        do {
            // Decode the JSON data into a StoryData object
            let story = try JSONDecoder().decode(StoryData.self, from: jsonData)
            return story
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(let key, let context):
                print("Key '\(key.stringValue)' not found: \(context.debugDescription). CodingPath: \(context.codingPath)")
                throw DecodingError.keyNotFound(key, context)
            case .typeMismatch(let type, let context):
                print("Type mismatch for type \(type): \(context.debugDescription). CodingPath: \(context.codingPath)")
                throw DecodingError.typeMismatch(type, context)
            case .valueNotFound(let type, let context):
                print("Value not found for type \(type): \(context.debugDescription). CodingPath: \(context.codingPath)")
                throw DecodingError.valueNotFound(type, context)
            case .dataCorrupted(let context):
                print("Data corrupted: \(context.debugDescription). CodingPath: \(context.codingPath)")
                throw DecodingError.dataCorrupted(context)
            default:
                print("Unknown decoding error: \(error.localizedDescription)")
                throw error
            }
        } catch {
            // If the error is not a DecodingError, log and rethrow the generic error
            print("Unknown error: \(error.localizedDescription)")
            throw error
        }
    }
}
