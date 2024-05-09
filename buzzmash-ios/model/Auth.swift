//
//  Auth.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation


struct AuthModel: Codable {
    let message, jwtToken: String
    let user: User
    let success: Bool
}

// MARK: - User
struct User: Codable {
    let id, name, username, email: String
    let password: String
    let instagram: String
    let twitter, facebook, dob: String
    let profilePicture: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, username, email, password, instagram, twitter, facebook
        case dob = "DOB"
        case profilePicture
        case v = "__v"
    }
}
