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
    var id, name, username, email: String
    var password: String
    var instagram: String
    var twitter, facebook, dob: String
    var profilePicture: String
    var v: Int

    enum CodingKeys: String, CodingKey {
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
