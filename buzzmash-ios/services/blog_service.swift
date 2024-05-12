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

//    func addBlogThumbnail()


}


final class BlogApiService:BlogApiServiceProtocol {
 
    

    
   
    
  
    
   
    
    private var cancellable: AnyCancellable?
    @Published var blogCategory:GetBlogCategory?
    @Published var blogFeed:BlogFeed?
    
    @Published var newBlog:NewBlog?
    @Published var updateBlog:UpdatedBlog?
    
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
    
 
    
}
