//
//  follow_user_repo.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

import Foundation
protocol FollowServiceRepoProtocol {
    func follow(following:String,resultHandler: @escaping (_ responseData: ResposeData<FollowUnfollowModel?>) -> ())
    func unfollow(following:String,resultHandler: @escaping (_ responseData: ResposeData<FollowUnfollowModel?>) -> ())

}


class FollowServiceRepo:FollowServiceRepoProtocol {
    
    var followService:FollowService
    
    init(followService: FollowService) {
        self.followService = followService
    }
    
    func follow(following: String, resultHandler: @escaping (ResposeData<FollowUnfollowModel?>) -> ()) {
        self.followService.follow(following: following, resultHandler: resultHandler)
    }
    func unfollow(following: String, resultHandler: @escaping (ResposeData<FollowUnfollowModel?>) -> ()) {
        self.followService.unfollow(following: following, resultHandler: resultHandler)
    }
    
}
