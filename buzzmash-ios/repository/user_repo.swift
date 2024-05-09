//
//  user_repo.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
protocol UserApiServiceRepoProtocol {
    func profile(resultHandler: @escaping (_ responseData: ResposeData<UserProfile?>) -> ())


}


final class UserApiServiceRepo : UserApiServiceRepoProtocol {
   
    
    var userServiceRepo:UserApiService
    
    init(userServiceRepo: UserApiService) {
        self.userServiceRepo = userServiceRepo
    }
    
    func profile(resultHandler: @escaping (ResposeData<UserProfile?>) -> ()) {
        self.userServiceRepo.profile(resultHandler: resultHandler)
    }
    
}

