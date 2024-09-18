//
//  LanguageManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

/* This file is UNUSED for now! */

import Foundation

final class LanguageManager: ObservableObject {
    
    // Singleton instance
    static let shared = LanguageManager()
    
    @Published var selectedLanguage: Language {
        didSet {
            // Persist the selected language in UserDefaults whenever it changes
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    // Private initializer to prevent creating multiple instances
    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Language.english.rawValue
        self.selectedLanguage = Language(rawValue: savedLanguage) ?? .english
    }
}
