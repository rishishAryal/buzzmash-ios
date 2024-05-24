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
    
    @Published var incorrectPassword:Bool = false
    @Published var isChangePasswordLoading:Bool = false
    @Published var changePasswordResponseMessage:String =  ""
    @Published var changePassword:ChangePasswordModel?
    
    @Published var isRegisterLoading:Bool = false
    @Published var registerResponseMessage:String =  ""
    @Published var register:AuthModel?
    
    @Published var isCheckEmailLoading:Bool = false
    @Published var  isCheckEmailResponseMessage:String =  ""
    @Published var  isCheckEmail:CheckEmailOrUsername?
    
    @Published var isCheckUsernameLoading:Bool = false
    @Published var  isCheckUsernameResponseMessage:String =  ""
    @Published var  isCheckUsername:CheckEmailOrUsername?
    
    
    final var authRepo:AuthApiServiceRepo
    
    init( authRepo: AuthApiServiceRepo) {
       
        self.authRepo = authRepo
        self.showSplash()
        self.getToken()
        self.isLoggedIn()
        
    }
    
    
    func logout(completion:@escaping(_ logout:Bool)->()) {
        UserDefaults.standard.removeObject(forKey: ApplicationText.token)
        self.showSplash()
        self.getToken()
        self.isLoggedIn()
        completion(true)

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
    

    
    func loginUser(email: String, pasword:String, completion:@escaping(_ isSuccess:Bool)->()) {
        
        self.isLoginLoading = true
        
        self.authRepo.login(email: email, password: pasword) { response in
            self.login = response.responseData
            
            if(response.errorMessage != "" || !response.isSucess){
                self.loginResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.isLoginLoading = false
                    self.loginResponseMessage = ""
                    completion(false)
                    
                    
                }
            } else {
                self.isLoginLoading = false
                UserDefaults.standard.set(self.login!.jwtToken, forKey: ApplicationText.token)
                UserDefaults.standard.set(self.login?.user.id, forKey: "userId")
                completion(true)
                self.isUserLogin = true

            }
        }
        
        
    }

    
    
    func registerUser(email:String,password:String,name:String,username:String,DOB:String, completion:@escaping(_ isSuccess:Bool)->()){
        
        self.isRegisterLoading = true
        
        self.authRepo.register(email: email, password: password, username: username,name: name,DOB: DOB) { response in
            self.register = response.responseData
            
            if(response.errorMessage != "" || !response.isSucess){
                self.registerResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.isRegisterLoading = false
                    self.registerResponseMessage = ""
                    completion(false)
                    
                    
                }
            } else {
                self.isRegisterLoading = false
                UserDefaults.standard.set(self.register!.jwtToken, forKey: ApplicationText.token)
                UserDefaults.standard.set(self.register?.user.id, forKey: "userId")

                self.isUserLogin = true
                completion(true)
            }
        }
    }
    
    
    func changePassword(oldPassword:String , newPassword:String, completion: @escaping(_ isSuccess: Bool)->()) {
        
        self.isChangePasswordLoading  = true
        self.authRepo.changePassword(oldPassword: oldPassword, newPassword: newPassword) { response in
            self.changePassword = response.responseData
            
            if(response.errorMessage != "" || !response.isSucess){
                self.changePasswordResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.isChangePasswordLoading = false
                    self.changePasswordResponseMessage = ""
                   
                    completion(false)

                    
                }
            } else {
                self.isChangePasswordLoading = false
                completion(true)
            }
        }
    }
    
    
    func checkUsername(username:String, completion: @escaping(_ isAvailable:Bool, _ isSuccess: Bool)->()) {
        self.isCheckUsernameLoading = true
        self.authRepo.checkUsername(username: username) { response in
            self.isCheckUsername = response.responseData
            if(response.errorMessage != "" || !response.isSucess){
                self.isCheckUsernameResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.isCheckUsernameLoading = false
                    self.isCheckUsernameResponseMessage = ""
                   
                    completion(false, false)

                    
                }
            } else {
                completion(self.isCheckUsername!.isAvailable , true)
                self.isCheckUsernameLoading = false
                
            }
        }
    }
    
    func checkEmail(email:String, completion: @escaping(_ isAvailable:Bool, _ isSuccess: Bool)->()) {
        self.isCheckUsernameLoading = true
        self.authRepo.checkEmail(email: email) { response in
            self.isCheckEmail = response.responseData
            if(response.errorMessage != "" || !response.isSucess){
                self.isCheckEmailResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.isCheckEmailLoading = false
                    self.isCheckEmailResponseMessage = ""
                   
                    completion(false, false)

                    
                }
            } else {
                completion(self.isCheckEmail!.isAvailable , true)
                self.isCheckEmailLoading = false
                
            }
        }
    }


    
}
