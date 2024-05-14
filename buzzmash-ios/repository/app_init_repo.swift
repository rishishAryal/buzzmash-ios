//
//  app_init_repo.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/10/24.
//

import Foundation

protocol AppInitRepoProtocol {
    func getBlogCategory(resultHandler: @escaping (_ responseData: ResposeData<GetBlogCategory?>) -> ())
    func profile(resultHandler: @escaping (_ responseData: ResposeData<UserProfile?>) -> ())

}




final class AppInitRepo:AppInitRepoProtocol {
    
    
   
    
    var appInitRepo:AppInitService
    
    
    init(appInitRepo: AppInitService) {
        self.appInitRepo = appInitRepo
    }
    
    func getBlogCategory(resultHandler: @escaping (ResposeData<GetBlogCategory?>) -> ()) {
        self.appInitRepo.getBlogCategory(resultHandler: resultHandler)
    }
    
    func profile(resultHandler: @escaping (ResposeData<UserProfile?>) -> ()) {
        self.appInitRepo.profile(resultHandler: resultHandler)
    }
    
}
