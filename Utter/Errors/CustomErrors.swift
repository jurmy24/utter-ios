//
//  CustomErrors.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

// Custom error type for better error handling
enum UserManagerError: Error {
    case languageNotFound(String)

    var localizedDescription: String {
        switch self {
        case .languageNotFound(let language):
            return "User has no progress for language \(language)."
        }
    }
}

// Define custom error for handling story loading issues
enum StoryLoadingError: LocalizedError {
    case decodingFailed(reason: DecodingError)
    case other(error: Error)

    var errorDescription: String? {
        switch self {
        case .decodingFailed(let reason):
            return "Failed to decode the story: \(reason.localizedDescription)"
        case .other(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
