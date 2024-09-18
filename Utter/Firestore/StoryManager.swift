//
//  StoryManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-15.
//

import Foundation
import FirebaseFirestore


final class StoryManager {
    
    static let shared = StoryManager()
    private init() { }
    
    private let storyCollection = Firestore.firestore().collection("stories")
    
    private func storyDocument(storyId: String) -> DocumentReference {
        storyCollection.document(storyId)
    }
    
    func uploadStory(story: DBStory) async throws {
        try storyDocument(storyId: String(story.id)).setData(from: story, merge: false)
    }
    
    func getStory(storyId: String) async throws -> DBStory {
        try await storyDocument(storyId: storyId).getDocument(as: DBStory.self)
    }
    
    func getAllStories() async throws -> [DBStory] {
        try await storyCollection.getDocuments(as: DBStory.self)
    }
        
    func getAllStoriesByLanguage(language: StoryLanguage) async throws -> [DBStory] {
        try await storyCollection
            .whereField(DBStory.CodingKeys.language.rawValue, isEqualTo: language.rawValue)
            .order(by: DBStory.CodingKeys.level.rawValue, descending: false)
            .getDocuments(as: DBStory.self)
    }
}

extension Query {
    
//    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
//        let snapshot = try await self.getDocuments()
//        
//        return try snapshot.documents.map({ document in
//            return try document.data(as: T.self)
//        })
//    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let (products, _) = try await getDocumentsWithSnapshot(as: type)
        return products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> ([T], DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let stories = try snapshot.documents.map({ document in
            return try document.data(as: T.self)
        })
        
        return (stories, snapshot.documents.last)
    }
}
