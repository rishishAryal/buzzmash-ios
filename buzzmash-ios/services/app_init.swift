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

}



final class AppInitService:AppInitServiceProtocol {
    
    private var cancellable: AnyCancellable?
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
}
