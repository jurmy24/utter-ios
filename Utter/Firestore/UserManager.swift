//
//  UserManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import Foundation
import FirebaseFirestore

struct DBUser {
    let userId: String
    let dateCreated: Date?
    let email: String?
    let name: String?
    let avatar: String?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String:Any] = [
            "id" : auth.uid,
            "date_created" : Timestamp(),
            "email": auth.email ?? "",
            "name": auth.name ?? "",
            "avatar": "🐵"
        ]
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: true)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let dateCreated = data["date_created"] as? Date
        let email = data["email"] as? String
        let name = data["name"] as? String
        let avatar = data["avatar"] as? String
        
        return DBUser(userId: userId, dateCreated: dateCreated, email: email, name: name, avatar: avatar)
    }
}
