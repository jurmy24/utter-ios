//
//  LanguageManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import Foundation

final class LanguageManager: ObservableObject {
    
    // Singleton instance
    static let shared = LanguageManager()
    
    @Published var selectedLanguage: StoryLanguage {
        didSet {
            // Persist the selected language in UserDefaults whenever it changes
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    // Private initializer to prevent creating multiple instances
    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? StoryLanguage.english.rawValue
        self.selectedLanguage = StoryLanguage(rawValue: savedLanguage) ?? .english
    }
}
