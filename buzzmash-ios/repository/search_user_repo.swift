//
//  search_user_repo.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

import Foundation


protocol SearchUserRepoProtocol {
    
    func searchUser(search:String,resultHandler: @escaping (_ responseData: ResposeData<SearchUserModel?>) -> ())
}



class SearchUserRepo:SearchUserRepoProtocol {
    
    var searchUserService:SearchUserService
    init(searchUserService: SearchUserService) {
        self.searchUserService = searchUserService
    }
    
    func searchUser(search: String, resultHandler: @escaping (ResposeData<SearchUserModel?>) -> ()) {
        self.searchUserService.searchUser(search: search, resultHandler: resultHandler)
    }
    
    
}
