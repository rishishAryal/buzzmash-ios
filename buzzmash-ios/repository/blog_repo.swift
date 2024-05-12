//
//  blog_repo.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation


protocol BlogApiServiceRepoProtocol {
    
    
    func getBlogCategory(resultHandler: @escaping (_ responseData: ResposeData<GetBlogCategory?>) -> ())
    func getBlogFeed(resultHandler: @escaping (_ responseData: ResposeData<BlogFeed?>) -> ())
    func createBlog (title: String , description: String, category: String,resultHandler: @escaping (_ responseData: ResposeData<NewBlog?>) -> ())

    func updateBlog (author: String,title: String , description: String, category: String ,thumbnail:String,id:String,resultHandler: @escaping (_ responseData: ResposeData<UpdatedBlog?>) -> ())

    
}


final class BlogApiServiceRepo:BlogApiServiceRepoProtocol {
 
    
   
    

    
   
    
  
    
    var blogApiService:BlogApiService
    
    init(blogApiService: BlogApiService) {
        self.blogApiService = blogApiService
    }
    
    func getBlogCategory(resultHandler: @escaping (ResposeData<GetBlogCategory?>) -> ()) {
        self.blogApiService.getBlogCategory(resultHandler: resultHandler)
    }
    
    func getBlogFeed(resultHandler: @escaping (ResposeData<BlogFeed?>) -> ()) {
        self.blogApiService.getBlogFeed(resultHandler: resultHandler)
    }
    func createBlog(title: String, description: String, category: String, resultHandler: @escaping (ResposeData<NewBlog?>) -> ()) {
        self.blogApiService.createBlog(title: title, description: description, category: category, resultHandler: resultHandler)
    }
    
    func updateBlog(author: String, title: String, description: String, category: String, thumbnail: String, id: String, resultHandler: @escaping (ResposeData<UpdatedBlog?>) -> ()) {
        self.blogApiService.updateBlog(author: author, title: title, description: description, category: category, thumbnail: thumbnail, id: id, resultHandler: resultHandler)
    }
   
    
}
