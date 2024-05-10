//
//  blog_feed.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation


struct BlogFeed: Codable {
    let message: String
    let blogs: [Blog]
    let success: Bool
}

// MARK: - Blog
struct Blog: Codable {
    let id, title, description, slug: String
    let thumbnail: String
    let category, author, userID: String
    let likeCount, commentCount: Int
    let createdAt, updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, slug, thumbnail, category, author
        case userID = "userId"
        case likeCount, commentCount, createdAt, updatedAt
        case v = "__v"
    }
}

struct NewBlog: Codable {
    let message: String
    let blog: Blog
    let success: Bool
}

// MARK: - Blog

struct DeleteBlog: Codable {
    let message: String
    let success: Bool
}


struct AddBlogThumbnail: Codable {
    let message: String
    let success: Bool
    let thumbnail: String
}
