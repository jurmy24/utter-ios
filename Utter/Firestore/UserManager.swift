//
//  UserManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import Foundation
import FirebaseFirestore

enum CEFRLevel: String, Codable {
    case a1 = "a1"
    case a2 = "a2"
    case b1 = "b1"
    case b2 = "b2"
    case c1 = "c1"
    case c2 = "c2"
}

struct DBUser: Codable {
    let userId: String
    let dateCreated: Date?
    let email: String?
    let name: String?
    let avatar: String?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.dateCreated = Date()
        self.email = auth.email
        self.name = auth.name
        self.avatar = "🐶" // Set standard avatar as dog 🐶 by default
    }
    
    init(
        userId: String,
        dateCreated: Date? ,
        email: String? = nil,
        name: String? = nil,
        avatar: String? = nil
    ) {
        self.userId = userId
        self.dateCreated = dateCreated
        self.email = email
        self.name = name
        self.avatar = avatar // Set standard avatar as dog 🐶 by default
    }
    
    // These are used by the coders
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case dateCreated = "date_created"
        case email = "email"
        case name = "name"
        case avatar = "avatar"
    }
    
    // A decoder that converts the database keys like "user_id" to self.userId
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
    }
    
    // An encoder that converts eg self.userId to database keys like "user_id"
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.avatar, forKey: .avatar)
    }
}

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
    
    //    func newStoryUnlocked(userId: String, language: StoryLanguage, storyId: String) {
    //        try await userDocument(userId: userId).collection("languages_progress")
    //    }
    //
    //    func updateUserStoryProgress(userId: String, language: StoryLanguage) {
    //        try await userDocument(userId: userId).collection("languages_progress")
    //    }
    
}


struct UserLanguage: Codable {
    let id: String
    let language: StoryLanguage
    let currentCefr: CEFRLevel
    let startingDifficulty: Difficulty
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case language = "language"
        case currentCefr = "current_cefr"
        case startingDifficulty = "starting_difficulty"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.language = try container.decode(StoryLanguage.self, forKey: .language)
        self.currentCefr = try container.decode(CEFRLevel.self, forKey: .currentCefr)
        self.startingDifficulty = try container.decode(Difficulty.self, forKey: .startingDifficulty)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.language, forKey: .language)
        try container.encode(self.currentCefr, forKey: .currentCefr)
        try container.encode(self.startingDifficulty, forKey: .startingDifficulty)
    }
}
