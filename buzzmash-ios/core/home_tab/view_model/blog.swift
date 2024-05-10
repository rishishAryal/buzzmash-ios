//
//  blog.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
import Combine

class BlogViewModel:ObservableObject {
    @Published var getBlogCategoryIsLoading:Bool = false
    @Published var getBlogCategory:GetBlogCategory?
    @Published var getBlogCategoryResponse:String = ""
    @Published var requiredBlogCategory:[Category] = []
    @Published var getBlogFeedIsLoading:Bool = false
    @Published var getBlogFeed:BlogFeed?
    @Published var getBlogFeedResponse:String = ""
    @Published var requiredBlogFeed:[Blog] = []
    @Published var isLoading:Bool = false
    @Published var response:String = ""
    @Published var newBlog:NewBlog?

    
    

    final var blogRepo:BlogApiServiceRepo
    
    init(blogRepo: BlogApiServiceRepo) {
       
        self.blogRepo = blogRepo
        self.getFeed() {_ in
            
            self.getCategory()

        }
    }
    
    
    func getCategory(){
        self.getBlogCategoryIsLoading = true
        self.blogRepo.getBlogCategory { response in
            self.getBlogCategory = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.getBlogCategoryResponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.getBlogCategoryResponse = ""
                    self.getBlogCategoryIsLoading = false

                    
                }
            } else {
                self.requiredBlogCategory = self.getBlogCategory?.categories ?? []
                self.getBlogCategoryIsLoading = false
            }
        }
        
    }
    
    
    func getFeed(completion :@escaping(_ isSuccess: Bool)-> ()){
        self.getBlogFeedIsLoading = true
        self.blogRepo.getBlogFeed { response in
            self.getBlogFeed = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.getBlogFeedResponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.getBlogFeedResponse = ""
                    self.getBlogFeedIsLoading = false
                    completion(false)

                    
                }
            } else {
                self.requiredBlogFeed = self.getBlogFeed?.blogs ?? []
                self.getBlogFeedIsLoading = false
                completion(true)
            }
        }
        
    }
    
    
    func create(title: String, category:String, description:String, completion
                :@escaping(_ success:Bool)->()){
        
        self.isLoading = true
        self.blogRepo.createBlog(title: title, description: description, category: category) { response in
            self.newBlog = response.responseData
            
            if(response.errorMessage != "" || !response.isSucess) {
                self.response = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.response = ""
                    self.isLoading = false
                    completion(false)

                    
                }
            } else {
                self.requiredBlogFeed.append(self.newBlog!.blog )
                self.isLoading = false
                completion(true)
            }
        }
        
        
    }
    
    

    
}
