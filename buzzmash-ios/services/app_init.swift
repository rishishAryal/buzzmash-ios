//
//  app_init.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/10/24.
//

import Foundation
import Combine

protocol AppInitServiceProtocol {
    func getBlogCategory(resultHandler: @escaping (_ responseData: ResposeData<GetBlogCategory?>) -> ())
    func profile(resultHandler: @escaping (_ responseData: ResposeData<UserProfile?>) -> ())

}



final class AppInitService:AppInitServiceProtocol {
    
    private var cancellable: AnyCancellable?
    @Published var profile:UserProfile?
    @Published var blogCategory:GetBlogCategory?
    
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
}
