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


}


final class UserApiService:UserApiServiceProtocol {
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
    @Published var profile:UserProfile?
    private var cancellable: AnyCancellable?

}
