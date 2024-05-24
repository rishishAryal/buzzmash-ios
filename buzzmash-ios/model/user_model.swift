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
    var followerCount, followingCount: Int
    var id, name, username, email: String
    var password, instagram, twitter, facebook: String
    let dob: String
    var profilePicture: String
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



struct ProfilePictureUpdateModel: Codable {
    let message: String
    let success: Bool
    var profilePicture: String
}
