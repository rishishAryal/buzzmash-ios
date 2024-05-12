//
//  auth_repo.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation

protocol AuthApiServiceRepoProtocol {
    
    
    func login(email: String, password:String, resultHandler: @escaping (_ responseData: ResposeData<AuthModel?>) -> ())
    func changePassword(oldPassword: String, newPassword:String, resultHandler: @escaping (_ responseData: ResposeData<ChangePasswordModel?>) -> ())



    
}


final class AuthApiServiceRepo:AuthApiServiceRepoProtocol {
  
    
    
    
     var authService:AuthApiService
    
    init(authService: AuthApiService) {
        self.authService = authService
    }
    
    func login(email: String, password: String, resultHandler: @escaping (ResposeData<AuthModel?>) -> ()) {
        self.authService.login(email: email, password: password, resultHandler: resultHandler)
    }
    
    func changePassword(oldPassword: String, newPassword: String, resultHandler: @escaping (ResposeData<ChangePasswordModel?>) -> ()) {
        self.authService.changePassword(oldPassword: oldPassword, newPassword: newPassword, resultHandler: resultHandler)
    }
    
    
}
