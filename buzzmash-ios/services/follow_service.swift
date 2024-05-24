//
//  follow_service.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

import Foundation
import Combine

protocol FollowServiceProtocol {
    func follow(following:String,resultHandler: @escaping (_ responseData: ResposeData<FollowUnfollowModel?>) -> ())
    func unfollow(following:String,resultHandler: @escaping (_ responseData: ResposeData<FollowUnfollowModel?>) -> ())
    func getFollowers(resultHandler: @escaping (_ responseData: ResposeData<UserFollowerModel?>) -> ())
    func getFollowings(resultHandler: @escaping (_ responseData: ResposeData<UserFollowingModel?>) -> ())
    
    

}

class FollowService:FollowServiceProtocol {
   
    
    private var cancellable: AnyCancellable?
    @Published var follow:FollowUnfollowModel?
    @Published var unfollow:FollowUnfollowModel?
    @Published var followers:UserFollowerModel?
    @Published var followings:UserFollowingModel?
    
    func follow(following: String, resultHandler: @escaping (ResposeData<FollowUnfollowModel?>) -> ()) {
        guard let url = URL(string: ApiUrl.follow) else {
            print("Invalid URL")
            return
            
           
        }
        let credentials = ["following": following] as [String:Any]
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.post, url: url, credentials: credentials  )
                .decode(type: FollowUnfollowModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<FollowUnfollowModel?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.follow = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<FollowUnfollowModel?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.follow ))
                })
        } catch {
            print("The file could not be loaded")
        }

    }
    func unfollow(following: String, resultHandler: @escaping (ResposeData<FollowUnfollowModel?>) -> ()) {
        guard let url = URL(string: ApiUrl.unfollow) else {
            print("Invalid URL")
            return
            
           
        }
        let credentials = ["following": following] as [String:Any]
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.post, url: url, credentials: credentials  )
                .decode(type: FollowUnfollowModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<FollowUnfollowModel?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.unfollow = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<FollowUnfollowModel?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.unfollow ))
                })
        } catch {
            print("The file could not be loaded")
        }
    }
    
    func getFollowers(resultHandler: @escaping (ResposeData<UserFollowerModel?>) -> ()) {
        guard let url = URL(string: ApiUrl.getFollowers) else {
            print("Invalid URL")
            return
        }
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.get, url: url )
                .decode(type: UserFollowerModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<UserFollowerModel?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.followers = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<UserFollowerModel?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.followers ))
                })
        } catch {
            print("The file could not be loaded")
        }
        
    }
    
    func getFollowings(resultHandler: @escaping (ResposeData<UserFollowingModel?>) -> ()) {
        guard let url = URL(string: ApiUrl.getFollowings) else {
            print("Invalid URL")
            return
        }
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.get, url: url )
                .decode(type: UserFollowingModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<UserFollowingModel?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.followings = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<UserFollowingModel?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.followings ))
                })
        } catch {
            print("The file could not be loaded")
        }
    }

}
