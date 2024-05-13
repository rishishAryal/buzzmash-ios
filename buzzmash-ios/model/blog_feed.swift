//
//  blog_feed.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation


struct BlogFeed: Codable {
    var message: String
    var blogs: [Blog]
    var success: Bool
}

// MARK: - Blog
struct Blog: Codable {
    var id, title, description, slug: String
    var thumbnail: String
    var category, author, userID: String
    var likeCount, commentCount: Int
    var createdAt, updatedAt: String
    var v: Int

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
    var blog: Blog
    let success: Bool
}

struct UpdatedBlog: Codable {
    let message: String
    let success: Bool
    let updatedBlog: Blog
}

// MARK: - UpdatedBlog



// MARK: - Blog

struct DeleteBlog: Codable {
    let message: String
    let success: Bool
}


struct AddBlogThumbnail: Codable {
    let message: String
    let success: Bool
    var thumbnail: String
}


struct GetBlogByCategory: Codable {
    let message: String
    let blogs: [Blog]
    let count: Int
    let success: Bool
}
struct BlogLikeModel: Codable {
    let message: String
    let success: Bool
}


// MARK: - Blog
//struct Blog: Codable {
//    let id, title, description, slug: String
//    let thumbnail: String
//    let category, author, userID: String
//    let likeCount, commentCount: Int
//    let createdAt, updatedAt: String
//    let v: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case title, description, slug, thumbnail, category, author
//        case userID = "userId"
//        case likeCount, commentCount, createdAt, updatedAt
//        case v = "__v"
//    }
//}
