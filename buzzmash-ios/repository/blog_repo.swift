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
    func getBlogFeedByCategory(category:String,resultHandler: @escaping (_ responseData: ResposeData<GetBlogByCategory?>) -> ())
    func likeUnlikeBlog(blogId: String , resultHandler: @escaping (_ responseData: ResposeData<BlogLikeModel?>) -> () )
    func getComments(blogId:String,resultHandler: @escaping (_ responseData: ResposeData<GetCommentModel?>) -> ())
    func postCommen(blogId: String, comment:String,resultHandler: @escaping (_ responseData: ResposeData<PostComment?>) -> () )



    
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
    func getBlogFeedByCategory(category: String, resultHandler: @escaping (ResposeData<GetBlogByCategory?>) -> ()) {
        self.blogApiService.getBlogFeedByCategory(category: category, resultHandler: resultHandler)
    }
    func likeUnlikeBlog(blogId: String, resultHandler: @escaping (ResposeData<BlogLikeModel?>) -> ()) {
        self.blogApiService.likeUnlikeBlog(blogId: blogId, resultHandler: resultHandler)
    }
    func getComments(blogId: String, resultHandler: @escaping (ResposeData<GetCommentModel?>) -> ()) {
        self.blogApiService.getComments(blogId: blogId, resultHandler: resultHandler)
    }
    func postCommen(blogId: String, comment: String, resultHandler: @escaping (ResposeData<PostComment?>) -> ()) {
        self.blogApiService.postCommen(blogId: blogId, comment: comment, resultHandler: resultHandler)
    }
}
