//
//  user_model.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation


struct UserProfile: Codable {
    let message: String
    var profile: Profile
}

// MARK: - Profile
struct Profile: Codable {
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


struct ProfilePictureUpdateModel: Codable {
    let message: String
    let success: Bool
    var profilePicture: String
}
