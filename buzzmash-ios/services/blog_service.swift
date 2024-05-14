//
//  blog_service.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
import Combine


protocol BlogApiServiceProtocol {
    func getBlogCategory(resultHandler: @escaping (_ responseData: ResposeData<GetBlogCategory?>) -> ())
    func getBlogFeed(resultHandler: @escaping (_ responseData: ResposeData<BlogFeed?>) -> ())
    func createBlog (title: String , description: String, category: String,resultHandler: @escaping (_ responseData: ResposeData<NewBlog?>) -> ())
    func updateBlog (author: String,title: String , description: String, category: String ,thumbnail:String,id:String,resultHandler: @escaping (_ responseData: ResposeData<UpdatedBlog?>) -> ())
    func getBlogFeedByCategory(category:String,resultHandler: @escaping (_ responseData: ResposeData<GetBlogByCategory?>) -> ())
    func likeUnlikeBlog(blogId: String , resultHandler: @escaping (_ responseData: ResposeData<BlogLikeModel?>) -> () )
    func getComments(blogId:String,resultHandler: @escaping (_ responseData: ResposeData<GetCommentModel?>) -> ())
    func postCommen(blogId: String, comment:String,resultHandler: @escaping (_ responseData: ResposeData<PostComment?>) -> () )
    func deleteComment(commentId:String,resultHandler: @escaping (_ responseData: ResposeData<DeleteComment?>) -> ())
    func updateComment(commentId:String, comment: String , resultHandler: @escaping (_ responseData: ResposeData<UpdateComment?>) -> ())


//    func addBlogThumbnail()


}


final class BlogApiService:BlogApiServiceProtocol {

    

    

  
    
   //https://buzzmash.onrender.com/api/v1/blog/deleteComment/6642feda4fe74e3fb5db6957
    
 
    

    
   
    //https://buzzmash.onrender.com/api/v1/blog/getComments/662a338dda505f5eebbabf22
  
    
   
    
    private var cancellable: AnyCancellable?
    @Published var blogCategory:GetBlogCategory?
    @Published var blogFeed:BlogFeed?
    
    @Published var newBlog:NewBlog?
    @Published var updateBlog:UpdatedBlog?
    @Published var blogFeedByCategory:GetBlogByCategory?
    @Published var like:BlogLikeModel?
    @Published var comment:GetCommentModel?
    @Published var newComment:PostComment?
    @Published var deleteComment:DeleteComment?
    @Published var updateComment:UpdateComment?
    
    func getBlogCategory(resultHandler: @escaping (ResposeData<GetBlogCategory?>) -> ()) {
        guard let url = URL(string: ApiUrl.getBlogCategory) else {
            print("Invalid URL")
            return
            
           
        }
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.get, url: url  )
                .decode(type: GetBlogCategory.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<GetBlogCategory?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.blogCategory = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<GetBlogCategory?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.blogCategory ))
                })
        } catch {
            print("The file could not be loaded")
        }
        
    }
    
    func getBlogFeed(resultHandler: @escaping (ResposeData<BlogFeed?>) -> ()) {
        guard let url = URL(string: ApiUrl.getBlogFeed) else {
            print("Invalid URL")
            return
            
           
        }
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.get, url: url  )
                .decode(type: BlogFeed.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<BlogFeed?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.blogFeed = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<BlogFeed?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.blogFeed ))
                })
        } catch {
            print("The file could not be loaded")
        }
        
    }
    func createBlog(title: String, description: String, category: String, resultHandler: @escaping (ResposeData<NewBlog?>) -> ()) {
        guard let url = URL(string: ApiUrl.createBlog) else {
            print("Invalid URL")
            return
            
           
        }
        let credentials = ["title": title, "description": description, "category": category ] as [String: Any]
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.post, url: url , credentials: credentials )
                .decode(type: NewBlog.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<NewBlog?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.newBlog = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<NewBlog?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.newBlog ))
                })
        } catch {
            print("The file could not be loaded")

        }
        
        
    }
    
    func updateBlog(author: String, title: String, description: String, category: String, thumbnail: String,id: String, resultHandler: @escaping (ResposeData<UpdatedBlog?>) -> ()) {
        
        guard let url = URL(string: "https://buzzmash.onrender.com/api/v1/blog/update/\(id)") else {
            print("Invalid URL")
            return
            
           
        }
        let credentials = ["title": title, "description": description, "category": category, "author": author, "thumbnail": thumbnail ] as [String: Any]
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.put, url: url , credentials: credentials )
                .decode(type: UpdatedBlog.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<UpdatedBlog?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.updateBlog = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<UpdatedBlog?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.updateBlog ))
                })
        } catch {
            print("The file could not be loaded")

        }
        
    }
    
    
    func getBlogFeedByCategory(category:String,resultHandler: @escaping (ResposeData<GetBlogByCategory?>) -> ()) {
        guard let url = URL(string: ApiUrl.getBlogByCategory) else {
            print("Invalid URL")
            return
        }
        let credentials = ["category": category] as [String:Any]
        
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.post, url: url, credentials: credentials)
                .decode(type: GetBlogByCategory.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        resultHandler (ResposeData<GetBlogByCategory?>(isLoading: false, errorMessage:  String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue:    {[weak self] (receiveData) in
                    self?.blogFeedByCategory  = receiveData
                    
                    resultHandler (ResposeData(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.blogFeedByCategory))
                    
                })
        } catch {
            print("The file could not be loaded")

        }
        
    }
    
    func likeUnlikeBlog(blogId: String, resultHandler: @escaping (ResposeData<BlogLikeModel?>) -> ()) {
        guard let url = URL(string: ApiUrl.likeBlog) else {
            print("Invalid URL")
            return
        }
        let credentials = ["blogId": blogId] as [String:Any]

        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.post, url: url, credentials: credentials)
                .decode(type: BlogLikeModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        resultHandler (ResposeData<BlogLikeModel?>(isLoading: false, errorMessage:  String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue:    {[weak self] (receiveData) in
                    self?.like  = receiveData
                    
                    resultHandler (ResposeData(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.like))
                    
                })
        } catch {
            print("The file could not be loaded")

        }
        
    }
    
    func postCommen(blogId: String, comment: String, resultHandler: @escaping (ResposeData<PostComment?>) -> ()) {
        guard let url = URL(string: ApiUrl.comment) else {
            print("Invalid URL")
            return
        }
        let credentials = ["blogId": blogId, "comment": comment] as [String:Any]

        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.post, url: url, credentials: credentials)
                .decode(type: PostComment.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        resultHandler (ResposeData<PostComment?>(isLoading: false, errorMessage:  String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue:    {[weak self] (receiveData) in
                    self?.newComment  = receiveData
                    
                    resultHandler (ResposeData(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.newComment))
                    
                })
        } catch {
            print("The file could not be loaded")

        }
    }
    
    func getComments(blogId:String,resultHandler: @escaping (ResposeData<GetCommentModel?>) -> ()) {
        guard let url = URL(string: "https://buzzmash.onrender.com/api/v1/blog/getComments/\(blogId)" ) else {
            print("Invalid URL")
            return
            
           
        }
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.get, url: url  )
                .decode(type: GetCommentModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<GetCommentModel?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.comment = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<GetCommentModel?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.comment ))
                })
        } catch {
            print("The file could not be loaded")
        }
    }
    
    func deleteComment(commentId:String,resultHandler: @escaping (ResposeData<DeleteComment?>) -> ()) {
        guard let url = URL(string: "https://buzzmash.onrender.com/api/v1/blog/deleteComment/\(commentId)" ) else {
            print("Invalid URL")
            return
            
           
        }
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.delete, url: url  )
                .decode(type: DeleteComment.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<DeleteComment?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.deleteComment = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<DeleteComment?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.deleteComment ))
                })
        } catch {
            print("The file could not be loaded")
        }
        
    }
    
    func updateComment(commentId: String, comment: String, resultHandler: @escaping (ResposeData<UpdateComment?>) -> ()) {
        guard let url = URL(string: "https://buzzmash.onrender.com/api/v1/blog/updateComment/\(commentId)" ) else {
            print("Invalid URL")
            return
            
           
        }
        let credentials = ["comment": comment] as [String:Any]
        
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.put, url: url, credentials: credentials  )
                .decode(type: UpdateComment.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<UpdateComment?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.updateComment = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<UpdateComment?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.updateComment ))
                })
        } catch {
            print("The file could not be loaded")
        }
    }
}
