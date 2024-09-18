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
    
    func getUserLanguages(userId: String) async throws -> [UserLanguage] {
        return try await userLanguageCollection(userId: userId).getDocuments(as: UserLanguage.self)
    }
    
    func addNewLanguage(userId: String, language: StoryLanguage) async throws {
        let document = userLanguageCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String: Any] = [
            UserLanguage.CodingKeys.id.rawValue: documentId,
            UserLanguage.CodingKeys.language.rawValue: language.rawValue,
            UserLanguage.CodingKeys.currentCefr.rawValue: CEFRLevel.a1.rawValue, // set to a1 by default now
            UserLanguage.CodingKeys.startingDifficulty.rawValue: Difficulty.beginner.rawValue // set to beginner by default now
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func getUserLanguageStories(userId: String, language: StoryLanguage) async throws -> [UserStory] {
        // 1. Fetch the user's languages
        let userLanguages = try await getUserLanguages(userId: userId)

        // 2. Find the language document ID matching the specified language
        guard let languageProgress = userLanguages.first(where: { $0.language == language }) else {
            throw UserManagerError.languageNotFound(language.rawValue)
        }

        let languageDocumentId = languageProgress.id

        // 3. Fetch the user's stories for the specified language
        let stories = try await userLanguageStoryCollection(userId: userId, languageDocumentId: languageDocumentId).getDocuments(as: UserStory.self)

        return stories
    }
    
    //    func newStoryUnlocked(userId: String, language: StoryLanguage, storyId: String) {
    //        try await userDocument(userId: userId).collection("languages_progress")
    //    }
    //
    //    func updateUserStoryProgress(userId: String, language: StoryLanguage) {
    //        try await userDocument(userId: userId).collection("languages_progress")
    //    }
    
}
