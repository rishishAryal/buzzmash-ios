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
    @Published var getBlogDashboardIsLoading:Bool = false
    @Published var getBlogDashboard:BlogFeed?
    @Published var getBlogDashboardResponse:String = ""
    @Published var requiredBlogDashboard:[Blog] = []
    @Published var isDashboardCalled:Bool = false
    
    @Published var deleteisLoading:Bool = false
    @Published var deleteresponseMessage:String = ""
    @Published var delete:DeleteBlog?
    
    

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
    
    func getUserDasboardBlogs(completion :@escaping(_ isSuccess: Bool)-> ()){
        self.isDashboardCalled = true
        self.getBlogDashboardIsLoading = true
        self.userRepo.getUserBlog { response in
            self.getBlogDashboard = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.getBlogDashboardResponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.getBlogDashboardResponse = ""
                    self.getBlogDashboardIsLoading = false
                    completion(false)

                    
                }
            } else {
                self.requiredBlogDashboard = self.getBlogDashboard?.blogs ?? []
                self.getBlogDashboardIsLoading = false
                completion(true)
            }
        }
        
    }
    
    func deleteBlog(id:String, completion :@escaping(_ isSuccess: Bool)-> ()) {
        self.deleteisLoading = true
        self.userRepo.deleteBlog(id: id) { response in
            self.delete = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.deleteresponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.deleteresponseMessage = ""
                    self.deleteisLoading = false
                    completion(false)

                    
                }
            } else {
                self.deleteisLoading = false
                completion(true)
            }
        }
    }
    
    
    
}
