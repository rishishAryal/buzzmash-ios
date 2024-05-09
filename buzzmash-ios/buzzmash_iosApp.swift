//
//  buzzmash_iosApp.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

@main
struct buzzmash_iosApp: App {
    @StateObject var authVm:AuthViewModel = AuthViewModel(authRepo: AuthApiServiceRepo(authService: AuthApiService()))

    var body: some Scene {
        WindowGroup {
            
           
            HomeTab().environmentObject(authVm)
          
                
            
           
        }
    }
}
