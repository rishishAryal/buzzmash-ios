//
//  user_repo.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
protocol UserApiServiceRepoProtocol {
    func profile(resultHandler: @escaping (_ responseData: ResposeData<UserProfile?>) -> ())
    func getUserBlog(resultHandler: @escaping (_ responseData: ResposeData<BlogFeed?>) -> ())
    func deleteBlog(id: String,resultHandler: @escaping (_ responseData: ResposeData<DeleteBlog?>) -> ())
    func updateUserDetails(name: String, username:String,instagram: String, facebook: String,twitter: String , resultHandler: @escaping (_ responseData: ResposeData<UpdateUserModel?>) -> ())


}


final class UserApiServiceRepo : UserApiServiceRepoProtocol {
   
    
   
    
    var userServiceRepo:UserApiService
    
    init(userServiceRepo: UserApiService) {
        self.userServiceRepo = userServiceRepo
    }
    
    func profile(resultHandler: @escaping (ResposeData<UserProfile?>) -> ()) {
        self.userServiceRepo.profile(resultHandler: resultHandler)
    }
    
    func getUserBlog(resultHandler: @escaping (ResposeData<BlogFeed?>) -> ()) {
        self.userServiceRepo.getUserBlog(resultHandler: resultHandler)
    }
    
    func deleteBlog(id: String, resultHandler: @escaping (ResposeData<DeleteBlog?>) -> ()) {
        self.userServiceRepo.deleteBlog(id: id, resultHandler: resultHandler)
    }
    
    func updateUserDetails(name: String, username: String, instagram: String, facebook: String, twitter: String, resultHandler: @escaping (ResposeData<UpdateUserModel?>) -> ()) {
        self.userServiceRepo.updateUserDetails(name: name, username: username, instagram: instagram, facebook: facebook, twitter: twitter, resultHandler: resultHandler)
    }
}

