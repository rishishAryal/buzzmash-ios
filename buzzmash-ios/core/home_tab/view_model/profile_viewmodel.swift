//
//  profile_viewmodel.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation


class UserViewModel:ObservableObject {
    @Published var isLoading:Bool = false
    @Published var responseMessage:String = ""
    @Published var profile:UserProfile?
    
    final var userRepo:UserApiServiceRepo
    
    
    init(userRepo: UserApiServiceRepo) {
        self.userRepo = userRepo
        self.getUserProfile()
    }
    
    
    
    func getUserProfile() {
        self.isLoading = true
        
        self.userRepo.profile { response in
            self.profile = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.responseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.responseMessage = ""
                    self.isLoading = false

                    
                }
            } else {
//                self.requiredBlogCategory = self.getBlogCategory?.categories ?? []
                self.isLoading = false
            }
            
            
        }
    }
    
    
    
}
