//
//  UserManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import Foundation
import FirebaseFirestore

struct DBUser: Codable {
    let userId: String
    let dateCreated: Date?
    let email: String?
    let name: String?
    var avatar: String?
    
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
    
    mutating func updateUserAvatar(avatar: String) {
        self.avatar = avatar
    }
    
    //    func updateUserAvatar(avatar: String) -> DBUser {
    //        return DBUser(
    //            userId: userId,
    //            dateCreated: dateCreated,
    //            email: email,
    //            name: name,
    //            avatar: avatar)
    //    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    
    //    func createNewUser(auth: AuthDataResultModel) async throws {
    //        var userData: [String:Any] = [
    //            "id" : auth.uid,
    //            "date_created" : Timestamp(),
    //            "email": auth.email ?? "",
    //            "name": auth.name ?? "",
    //            "avatar": "🐵"
    //        ]
    //
    //        try await userDocument(userId: auth.uid).setData(userData, merge: false)
    //    }
    
    func getUser(userId: String) async throws -> DBUser {
        return try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
    }
    
    //    func getUser(userId: String) async throws -> DBUser {
    //        let snapshot = try await userDocument(userId: userId).getDocument()
    //
    //        guard let data = snapshot.data(), let userId = data["id"] as? String else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //        let dateCreated = data["date_created"] as? Date
    //        let email = data["email"] as? String
    //        let name = data["name"] as? String
    //        let avatar = data["avatar"] as? String
    //
    //        return DBUser(userId: userId, dateCreated: dateCreated, email: email, name: name, avatar: avatar)
    //    }
    
    func updateUserAvatar(userId: String, avatar: String) async throws {
        let data: [String:Any] = [
            "avatar" : avatar
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
}
