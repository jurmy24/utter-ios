//
//  DBUserModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

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
