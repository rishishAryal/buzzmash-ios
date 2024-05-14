//
//  Comment_Model.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/13/24.
//

import Foundation

struct GetCommentModel: Codable {
    var message: String
    var comments: [Comment]
    var success: Bool
}

// MARK: - Comment
struct Comment: Codable {
    var id, userID, blogID: String
    var comment:String
    var name: String
    var profilePicture: String
    var createdAt, updatedAt: String
    var v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case blogID = "blogId"
        case comment, name, profilePicture, createdAt, updatedAt
        case v = "__v"
    }
}


struct PostComment: Codable {
    let message: String
    let comment: Comment
    let success: Bool
}

// MARK: - Comment


struct DeleteComment: Codable {
    let message: String
    let success: Bool
}

struct UpdateComment: Codable {
    let message: String
    let success: Bool
}
