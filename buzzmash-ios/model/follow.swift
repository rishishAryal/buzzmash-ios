//
//  follow.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

import Foundation


struct SearchUserModel: Codable {
    let message: String
    let user: [SearchUser]
    let success: Bool
}

// MARK: - User
struct SearchUser: Codable {
    let id, name, username: String
    let profilePicture: String
    var isFollowing: Bool
}


struct FollowUnfollowModel:Codable {
    let message:String
    let success:Bool
}

struct UserFollowerModel: Codable {
    let success: Bool
    let message: String
    let followers: [Follower]
}

// MARK: - Follower
struct Follower: Codable {
    let id, username, email: String
    let profilePicture: String
    let isFollowing: Bool
}


struct UserFollowingModel: Codable {
    let following: [Following]
    let success: Bool
    let message: String
}

// MARK: - Following
struct Following: Codable {
    let id, username, email: String
    let profilePicture: String
    let isFollowing: Bool
}
