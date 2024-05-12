//
//  auth_Service.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
import Combine

protocol AuthApiServiceProtocol {
    func login(email: String, password:String, resultHandler: @escaping (_ responseData: ResposeData<AuthModel?>) -> ())
    func changePassword(oldPassword: String, newPassword:String, resultHandler: @escaping (_ responseData: ResposeData<ChangePasswordModel?>) -> ())


}


final class AuthApiService : AuthApiServiceProtocol {
  
    
  
    
    private var cancellable: AnyCancellable?
    @Published var auth:AuthModel?
    @Published var changePassword:ChangePasswordModel?
    
    
    
    func login(email: String, password: String, resultHandler: @escaping (ResposeData<AuthModel?>) -> ()) {
        
        guard let url = URL(string: ApiUrl.login) else {
            print("Invalid URL")
            return
        }
        let credentials = ["email": email , "password": password]  as [String: Any]
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.post, url: url, credentials: credentials  )
                .decode(type: AuthModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<AuthModel?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.auth = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<AuthModel?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.auth ))
                })
        } catch {
            print("The file could not be loaded")
        }
        
    }
    
    
    func changePassword(oldPassword: String, newPassword: String, resultHandler: @escaping (ResposeData<ChangePasswordModel?>) -> ()) {
        guard let url = URL(string: ApiUrl.changePassword) else {
            print("Invalid URL")
            return
        }
        
        let credentials = ["oldPassword": oldPassword , "newPassword": newPassword]  as [String: Any]
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.put, url: url, credentials: credentials  )
                .decode(type: ChangePasswordModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<ChangePasswordModel?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.changePassword = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<ChangePasswordModel?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.changePassword ))
                })
        } catch {
            print("The file could not be loaded")
        }
        

    }
    
}
