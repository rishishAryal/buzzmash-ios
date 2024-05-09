//
//  genric_response_data.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation

class  ResposeData<T> {
    
    let isLoading : Bool
    let errorMessage : String
    let isSucess :  Bool
    let responseData : T
    
    init(isLoading: Bool, errorMessage: String, isSucess: Bool, responseData: T) {
        self.isLoading = isLoading
        self.errorMessage = errorMessage
        self.isSucess = isSucess
        self.responseData = responseData
    }
    

    
}
