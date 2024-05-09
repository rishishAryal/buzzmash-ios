//
//  category.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation

struct GetBlogCategory: Codable {
    let message: String
    let categories: [Category]
    let success: Bool
}

// MARK: - Category
struct Category: Codable {
    let id, name: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case v = "__v"
    }
}
