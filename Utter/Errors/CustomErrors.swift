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
