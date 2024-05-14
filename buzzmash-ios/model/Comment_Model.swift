//
//  Comment_Model.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/13/24.
//

import Foundation

struct GetCommentModel: Codable {
    let message: String
    let comments: [Comment]
    let success: Bool
}

// MARK: - Comment
struct Comment: Codable {
    let id, userID, blogID, comment: String
    let name: String
    let profilePicture: String
    let createdAt, updatedAt: String
    let v: Int

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

