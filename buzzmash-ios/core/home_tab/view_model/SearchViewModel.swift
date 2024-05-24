//
//  SearchViewModel.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

import Foundation


class SearchViewModel:ObservableObject {
    @Published var isLoading:Bool = false
    @Published var responseMessage:String = ""
    @Published var searchUser:SearchUserModel?
    @Published var requiredSearchuser:[SearchUser] = []
    
    
    final var searchRepo:SearchUserRepo
    init(searchRepo: SearchUserRepo) {
       
        self.searchRepo = searchRepo
    }
    
    func searchUser(search:String, completion: @escaping(_ isSuccess:Bool)->()){
        self.isLoading = true
        self.searchRepo.searchUser(search: search) { response in
            self.searchUser = response.responseData
            if(response.errorMessage != "" || !response.isSucess){
                self.responseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.isLoading = false
                    self.responseMessage = ""
                    completion(false)
                }
            } else {
                
                
                self.requiredSearchuser = self.searchUser?.user ?? []
                self.isLoading = false
                completion(true)
                
            }
        }
    }
    
}
