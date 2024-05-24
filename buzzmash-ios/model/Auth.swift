//
//  Auth.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation


struct AuthModel: Codable {
    let message, jwtToken: String
    var user: User
    let success: Bool
}

// MARK: - User
struct User: Codable {
    var followerCount, followingCount: Int
    let id, name, username, email: String
    let password, instagram, twitter, facebook: String
    let dob: String
    let profilePicture: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case followerCount, followingCount
        case id = "_id"
        case name, username, email, password, instagram, twitter, facebook
        case dob = "DOB"
        case profilePicture
        case v = "__v"
    }
}



struct UpdateUserModel: Codable {
    let message: String
    let user: Profile
    let success: Bool
}





struct ChangePasswordModel: Codable {
    let message: String
    let success: Bool
}


struct CheckEmailOrUsername: Codable {
    let message: String
    let isAvailable: Bool
}
