//
//  blog.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
import Combine
import SwiftUI
import UIKit
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
    @Published var imageLoading:Bool = false
    @Published var updateBlogIsLoading:Bool = false
    @Published var updateBlogResponse:String = ""
    @Published var updatedBlog:UpdatedBlog?
    @Published var getFeedByCategory:GetBlogByCategory?
    
    
    
    
    @Published var islikeloading:Bool = false
    @Published var likeresponse:String = ""
    @Published var like:BlogLikeModel?
    
    @Published var getCommentisLoading:Bool = false
    @Published var getCommentResponse:String = ""
    @Published var getComment:GetCommentModel?
    @Published var requiredComment:[Comment] = []
    
    
    @Published var addCommentisLoading:Bool = false
    @Published var addCommentResponse:String = ""
    @Published var addComment:PostComment?

    
    
    
    
    
    final var blogRepo:BlogApiServiceRepo
    
    init(blogRepo: BlogApiServiceRepo) {
       
        self.blogRepo = blogRepo
        self.getFeed() {_ in
            
//            self.getCategory()

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
        self.requiredBlogFeed = []
        self.getBlogFeed = nil
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
    
    func uploadImage(image: UIImage,id:String, completion: @escaping (Bool, AddBlogThumbnail?, Error?) -> Void) {
        self.imageLoading = true
        let targetURL = URL(string: "https://buzzmash.onrender.com/api/v1/blog/addBlogThumbnail/\(id)")!

        // Create the request
        var request = URLRequest(url: targetURL)
        request.httpMethod = "POST"
        
        // Set the Authorization header if the token exists
        if let token = UserDefaults.standard.string(forKey: ApplicationText.token) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Define the multipart/form-data boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
             completion(false, nil, URLError(.cannotCreateFile))
             return
         }

        // Create HTTP body
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"thumbnail\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(false, nil, error)
                    return
                }
                do {
                    // Decode the JSON data into the AddBlogThumbnail struct
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(AddBlogThumbnail.self, from: data)
                    // Check for server-reported success
                    let isSuccess = responseData.success
                    self.imageLoading = false

                    completion(isSuccess, responseData, nil)
                } catch {
                    self.imageLoading = false

                    completion(false, nil, error)
                }
            }
        }.resume()

    }
    
    
    func update(author: String, title: String, description: String, category: String, thumbnail: String, id: String, completion
                :@escaping(_ success:Bool)->()){
        self.updateBlogIsLoading = true
        
        self.blogRepo.updateBlog(author: author, title: title, description: description, category: category, thumbnail: thumbnail, id: id) { response in
            self.updatedBlog = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.updateBlogResponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.updateBlogResponse = ""
                    self.updateBlogIsLoading = false
                    completion(false)

                }
            } else {
                self.updateBlogIsLoading = false
                completion(true)
            }
        }
    }
    
    
    func getFeedByCategory(category: String,completion :@escaping(_ isSuccess: Bool)-> ()){
        self.getBlogFeedIsLoading = true
        self.requiredBlogFeed = []
        self.getBlogFeed = nil
        self.blogRepo.getBlogFeedByCategory(category: category) { response in
            self.getFeedByCategory = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.getBlogFeedResponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.getBlogFeedResponse = ""
                    self.getBlogFeedIsLoading = false
                    completion(false)

                    
                }
            } else {
                self.requiredBlogFeed = self.getFeedByCategory?.blogs ?? []
                self.getBlogFeedIsLoading = false
                completion(true)
            }
        }
        
    }
    
    func likeunlikeBlog (blogId:String, completion: @escaping(_ Success:Bool)->()) {
        self.islikeloading = true
        self.blogRepo.likeUnlikeBlog(blogId: blogId) { response in
            self.like = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.likeresponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.likeresponse = ""
                    self.islikeloading = false
                    completion(false)

                    
                }
            } else {
                self.islikeloading = false
                completion(true)
            }
        }
    }
    
    func getComments(blogId:String, completion:@escaping(_ success: Bool)->()){
        self.requiredComment = []
        self.getCommentisLoading = true
        self.blogRepo.getComments(blogId: blogId) { response in
            if(response.errorMessage != "" || !response.isSucess) {
                self.getCommentResponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.getCommentResponse = ""
                    self.getCommentisLoading = false
                    completion(false)

                    
                }
            } else {
                
                
                
                self.requiredComment = response.responseData?.comments ?? []
                completion(true)
                self.getCommentisLoading = false
            }
        }
    }

    
    func addComment(blogId:String, comment:String,completion:@escaping(_ success: Bool)->() ) {
        self.addCommentisLoading = true
        self.blogRepo.postCommen(blogId: blogId, comment: comment) { response in
            self.addComment = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.addCommentResponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.addCommentResponse = ""
                    self.addCommentisLoading = false
                    completion(false)

                    
                }
            } else {
                
                
                
                self.requiredComment.append(response.responseData!.comment)
                completion(true)
                self.addCommentisLoading = false
            }
        }
    }
    
}
