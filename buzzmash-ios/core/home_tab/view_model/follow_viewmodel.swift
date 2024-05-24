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
    
    
    
    
}
