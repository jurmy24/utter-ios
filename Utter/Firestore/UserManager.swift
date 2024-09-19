//
//  UserManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import Foundation
import FirebaseFirestore


final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userLanguageCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("languages_progress")
    }
    
    private func userLanguageDocument(userId: String, languageDocumentId: String) -> DocumentReference {
        userLanguageCollection(userId: userId).document(languageDocumentId)
    }
    
    private func userLanguageStoryCollection(userId: String, languageDocumentId: String) -> CollectionReference {
        userLanguageDocument(userId: userId, languageDocumentId: languageDocumentId).collection("progress")
    }
    
    private func userLanguageStoryDocument(userId: String, languageDocumentId: String, storyId: String) -> DocumentReference {
        userLanguageStoryCollection(userId: userId, languageDocumentId: languageDocumentId).document(storyId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        return try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserAvatarStatus(userId: String, avatar: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.avatar.rawValue : avatar
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserName(userId: String, name: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.name.rawValue : name
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func getUserLanguages(userId: String) async throws -> [UserLanguageDetails] {
        return try await userLanguageCollection(userId: userId).getDocuments(as: UserLanguageDetails.self)
    }
    
    func addNewLanguage(userId: String, language: Language) async throws {
        let document = userLanguageCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String: Any] = [
            UserLanguageDetails.CodingKeys.id.rawValue: documentId,
            UserLanguageDetails.CodingKeys.language.rawValue: language.rawValue,
            UserLanguageDetails.CodingKeys.currentCefr.rawValue: CEFRLevel.a1.rawValue, // set to a1 by default now
            UserLanguageDetails.CodingKeys.startingDifficulty.rawValue: StoryDifficulty.beginner.rawValue // set to beginner by default now
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func getUserLanguageStories(userId: String, language: Language) async throws -> [UserStoryProgress] {
        // 1. Fetch the user's languages
        let userLanguages = try await getUserLanguages(userId: userId)

        // 2. Find the language document ID matching the specified language
        guard let languageProgress = userLanguages.first(where: { $0.language == language }) else {
            throw UserManagerError.languageNotFound(language.rawValue)
        }

        let languageDocumentId = languageProgress.id
        let languageCefr = languageProgress.currentCefr

        // 3. Fetch the user's stories for the specified language
        var stories = try await userLanguageStoryCollection(userId: userId, languageDocumentId: languageDocumentId).getDocuments(as: UserStoryProgress.self)
        
        // 4. Append the currentCefr to each UserStoryProgress
        stories = stories.map { story in
            var updatedStory = story
            updatedStory.currentCefr = languageCefr // Assign the currentCefr to each story
            return updatedStory
        }
        
        return stories
    }
    
    //    func newStoryUnlocked(userId: String, language: Language, storyId: String) {
    //        try await userDocument(userId: userId).collection("languages_progress")
    //    }
    //
    //    func updateUserStoryProgress(userId: String, language: Language) {
    //        try await userDocument(userId: userId).collection("languages_progress")
    //    }
    
}
