//
//  follow_viewmodel.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

import Foundation


class FollowViewModel:ObservableObject {
    @Published var isFollowLoading:Bool = false
    @Published var isFollowResponseMessage:String = ""
    @Published var followData:FollowUnfollowModel?
    
    @Published var isUnfollowLoading:Bool = false
    @Published var isUnfollowResponseMessage:String = ""
    @Published var unfollowData:FollowUnfollowModel?
    
    @Published var followingLoading:Bool = false
    @Published var followinResponseMessage:String = ""
    @Published var followingData:UserFollowingModel?
    @Published var requiredFollowingData:[Following] = []
    
    @Published var followerLoading:Bool = false
    @Published var followerResponseMessage:String = ""
    @Published var followerData:UserFollowerModel?
    @Published var requiredFollowerData:[Follower] = []
    
    @Published var followerMap:[String: [Follower]] = [:]
    @Published var followingMap:[String: [Following]] = [:]
    
    
    final var followRepo:FollowServiceRepo
    
    init(followRepo: FollowServiceRepo) {
        
        self.followRepo = followRepo
    }
    
    
    func follow(following:String, completion: @escaping(_ isSuccess: Bool)->()){
        self.isFollowLoading = true
        self.followRepo.follow(following: following) { response in
            self.followData = response.responseData
            if(response.errorMessage != "" || !response.isSucess){
                
                self.isFollowResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.isFollowResponseMessage = ""
                    self.isFollowLoading = false
                    completion(false)
                }
                
                
            } else {
                completion(true)
                self.isFollowLoading = false
                
            }
        }
        
    }
    func unfollow(following:String, completion: @escaping(_ isSucess: Bool)->()){
        
        self.isUnfollowLoading = true
        self.followRepo.unfollow(following: following) { response in
            self.followData = response.responseData
            if(response.errorMessage != "" || !response.isSucess){
                
                self.isUnfollowResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.isUnfollowResponseMessage = ""
                    self.isUnfollowLoading = false
                    completion(false)
                }
                
                
            } else {
                completion(true)
                self.isUnfollowLoading = false
                
            }
        }
        
        
    }
    
    
    func getFollowers(){
        self.followerLoading = true
        self.followRepo.getFollowers { response in
            self.followerData = response.responseData
            if(response.errorMessage != "" || !response.isSucess){
                self.followerResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.followerResponseMessage = ""
                    self.followerLoading = false
                    
                }
            } else {
                self.requiredFollowerData = self.followerData?.followers ?? []
                self.followerMap["follower"] = self.followerData?.followers ?? []
                self.followerLoading = false
                
            }
        }
    }
    
    func getFollowings(){
        self.followingLoading = true
        self.followRepo.getFollowings { response in
            self.followingData = response.responseData
            if(response.errorMessage != "" || !response.isSucess){
                self.followinResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.followinResponseMessage = ""
                    self.followingLoading = false
                    
                }
            } else {
                self.requiredFollowingData = self.followingData?.following ?? []
                self.followingMap["following"] = self.followingData?.following ?? [] 
                self.followingLoading = false
                
            }
        }
    }
    
}
