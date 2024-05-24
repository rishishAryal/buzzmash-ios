//
//  search_service.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

import Foundation
import Combine
protocol SearchUserServiceProtocol {
    func searchUser(search:String,resultHandler: @escaping (_ responseData: ResposeData<SearchUserModel?>) -> ())
}

class SearchUserService:SearchUserServiceProtocol {
   
    
    
    private var cancellable: AnyCancellable?
    @Published var searchUser:SearchUserModel?
    
    
    func searchUser(search: String, resultHandler: @escaping (ResposeData<SearchUserModel?>) -> ()) {
        
        guard let url = URL(string: ApiUrl.searchUser) else {
            print("Invalid URL")
            return
            
           
        }
        let credentials = ["search": search] as [String:Any]
        
        do {
            cancellable = try NetworkingManager.HandleAllUrlRequest(networkCallType: NetworkManagerEnum.post, url: url, credentials: credentials  )
                .decode(type: SearchUserModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        
                        resultHandler(ResposeData<SearchUserModel?>(isLoading: false, errorMessage: String(error.localizedDescription), isSucess: false, responseData: nil))
                    }
                }, receiveValue: { [weak self] (receivedData) in
                    self?.searchUser = receivedData
                   print("data recieved is \(receivedData)")
                    resultHandler(ResposeData<SearchUserModel?>(isLoading: false, errorMessage: "", isSucess: true, responseData: self?.searchUser ))
                })
        } catch {
            print("The file could not be loaded")
        }
        
        
    }
    
    
    
}
