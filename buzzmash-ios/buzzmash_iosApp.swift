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
    @StateObject var userVm:UserViewModel = UserViewModel(userRepo: UserApiServiceRepo(userServiceRepo: UserApiService()))
    var body: some Scene {
        WindowGroup {
            
           
            HomeTab(userVm: userVm).environmentObject(authVm)
          
                
            
           
        }
    }
}
