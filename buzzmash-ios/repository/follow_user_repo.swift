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
    func getFollowers(resultHandler: @escaping (_ responseData: ResposeData<UserFollowerModel?>) -> ())
    func getFollowings(resultHandler: @escaping (_ responseData: ResposeData<UserFollowingModel?>) -> ())

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
    
    func getFollowers(resultHandler: @escaping (ResposeData<UserFollowerModel?>) -> ()) {
        self.followService.getFollowers(resultHandler: resultHandler)
    }
    
    func getFollowings(resultHandler: @escaping (ResposeData<UserFollowingModel?>) -> ()) {
        self.followService.getFollowings(resultHandler: resultHandler)
    }
    
}
