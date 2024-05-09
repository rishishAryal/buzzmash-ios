//
//  auth_view_mode.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation


class AuthViewModel:ObservableObject {
    @Published var isLoginLoading:Bool = false
    @Published var loginResponseMessage:String =  ""
    @Published var login:AuthModel?
    @Published var token:String = ""
    @Published var isUserLogin:Bool = false
    @Published var showSplashScreen:Bool = false
    
    final var authRepo:AuthApiServiceRepo
    
    init( authRepo: AuthApiServiceRepo) {
       
        self.authRepo = authRepo
        self.showSplash()
        self.getToken()
        self.isLoggedIn()
        
    }
    
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: ApplicationText.token)
        self.showSplash()
        self.getToken()
        self.isLoggedIn()


    }
    
    func showSplash(){
        self.showSplashScreen = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showSplashScreen = false
          
        }
    }
    
    
    func getToken(){
        self.token = UserDefaults.standard.string(forKey: ApplicationText.token) ?? ""
    }
    
    func isLoggedIn() {
        
        if !self.token.isEmpty{
            self.isUserLogin =  true
        } else {
            self.showSplashScreen = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showSplashScreen = false
              
            }
            self.isUserLogin = false
        }
    }
    

    
    func loginUser(email: String, pasword:String) {
        
        self.isLoginLoading = true
        
        self.authRepo.login(email: email, password: pasword) { response in
            self.login = response.responseData
            
            if(response.errorMessage != "" || !response.isSucess){
                self.loginResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.isLoginLoading = false
                    self.loginResponseMessage = ""

                    
                }
            } else {
                self.isLoginLoading = false
                UserDefaults.standard.set(self.login!.jwtToken, forKey: ApplicationText.token)
                self.isUserLogin = true

            }
        }
        
        
    }


    
}
