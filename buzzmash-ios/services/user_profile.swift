//
//  user_profile.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
import Combine

protocol UserApiServiceProtocol {
    func profile(resultHandler: @escaping (_ responseData: ResposeData<UserProfile?>) -> ())
    func getUserBlog(resultHandler: @escaping (_ responseData: ResposeData<BlogFeed?>) -> ())
    func deleteBlog(id: String,resultHandler: @escaping (_ responseData: ResposeData<DeleteBlog?>) -> ())

}


final class UserApiService:UserApiServiceProtocol {

    
    
    @Published var getUserBlogs:BlogFeed?
    @Published var profile:UserProfile?
    @Published var delete:DeleteBlog?
    private var cancellable: AnyCancellable?

    func profile( resultHandler: @escaping (ResposeData<UserProfile?>) -> ()) {
        guard let url = URL(string: ApiUrl.fetchProfile) else {
            print("Invalid URL")
            return
        }
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.post, url: url)
                .decode(type: UserProfile.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<UserProfile?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.profile = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<UserProfile?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.profile ))
                })
        } catch {
            print("The file could not be loaded")
        }
    }
    
    func deleteBlog(id: String, resultHandler: @escaping (ResposeData<DeleteBlog?>) -> ()) {
        guard let url = URL(string: "https://buzzmash.onrender.com/api/v1/blog/delete/\(id)") else {
            print("Invalid URL")
            return
        }
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.delete, url: url  )
                .decode(type: DeleteBlog.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<DeleteBlog?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.delete = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<DeleteBlog?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.delete ))
                })
        } catch {
            print("The file could not be loaded")
        }
    }
    

    
    func getUserBlog(resultHandler: @escaping (ResposeData<BlogFeed?>) -> ()) {
        guard let url = URL(string: ApiUrl.getUserBlogs) else {
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
                    self?.getUserBlogs = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<BlogFeed?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.getUserBlogs ))
                })
        } catch {
            print("The file could not be loaded")
        }
    }
    
    
}
