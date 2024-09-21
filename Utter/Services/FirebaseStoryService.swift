//
//  FirebaseStoryService.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-21.
//

//import Foundation
//
//protocol FirebaseStoryServiceProtocol {
//    func loadStories(selectedLanguage: Language?) async -> ([DBStory], [UserStoryProgress])
//}
//
//struct FirebaseStoryService: FirebaseStoryServiceProtocol {
//    static let shared = FirebaseStoryService()
//    
//    func loadStories(selectedLanguage: Language? = .swedish) async -> ([DBStory], [UserStoryProgress]) {
//        guard let selectedLanguage = selectedLanguage else { return ([], []) }
//        do {
//            // Fetch stories and user progress
//            let dbStories = try await StoryManager.shared.getAllStoriesByLanguage(language: selectedLanguage)
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            let userProgresses = try await UserManager.shared.getUserLanguageStories(userId: authDataResult.uid, language: selectedLanguage)
//            
//            return (dbStories, userProgresses)
//            // Combine the stories with user progress
////            self.stories = getStories(dbStories: dbStories, userProgresses: userProgresses)
//        } catch {
//            print("Error loading stories with progress: \(error)")
//            return ([], [])
//        }
//    }
//    
//}
