//
//  profile_viewmodel.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
import Combine
import SwiftUI
import UIKit


class UserViewModel:ObservableObject {
    @Published var isLoading:Bool = false
    @Published var responseMessage:String = ""
    @Published var profile:UserProfile?
    @Published var getBlogDashboardIsLoading:Bool = false
    @Published var getBlogDashboard:BlogFeed?
    @Published var getBlogDashboardResponse:String = ""
    @Published var requiredBlogDashboard:[Blog] = []
    @Published var isDashboardCalled:Bool = false
    
    @Published var deleteisLoading:Bool = false
    @Published var deleteresponseMessage:String = ""
    @Published var delete:DeleteBlog?
    
    @Published var isupdateUserLoading:Bool = false
    @Published var updateUserResponseMessage:String =  ""
    @Published var updateUser:UpdateUserModel?
    
    @Published var imageUploadingLoading:Bool = false
    
    

    final var userRepo:UserApiServiceRepo
    
    
    init(userRepo: UserApiServiceRepo) {
        self.userRepo = userRepo
        self.getUserProfile()
    }
    
    
    
    func getUserProfile() {
        self.isLoading = true
        
        self.userRepo.profile { response in
            self.profile = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.responseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.responseMessage = ""
                    self.isLoading = false

                    
                }
            } else {
//                self.requiredBlogCategory = self.getBlogCategory?.categories ?? []
                UserDefaults.standard.set(self.profile!.profile.profilePicture, forKey: "profilePicture")

                self.isLoading = false
            }
            
            
        }
    }
    
    func getUserDasboardBlogs(completion :@escaping(_ isSuccess: Bool)-> ()){
        self.requiredBlogDashboard = []
        self.getBlogDashboard = nil
        self.isDashboardCalled = true
        self.getBlogDashboardIsLoading = true
        self.userRepo.getUserBlog { response in
            self.getBlogDashboard = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.getBlogDashboardResponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.getBlogDashboardResponse = ""
                    self.getBlogDashboardIsLoading = false
                    completion(false)

                    
                }
            } else {
                self.requiredBlogDashboard = self.getBlogDashboard?.blogs ?? []
                self.getBlogDashboardIsLoading = false
                completion(true)
            }
        }
        
    }
    
    func deleteBlog(id:String, completion :@escaping(_ isSuccess: Bool)-> ()) {
        self.deleteisLoading = true
        self.userRepo.deleteBlog(id: id) { response in
            self.delete = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.deleteresponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.deleteresponseMessage = ""
                    self.deleteisLoading = false
                    completion(false)

                    
                }
            } else {
                self.deleteisLoading = false
                completion(true)
            }
        }
    }
    
    func updateUserDetail(name: String, username: String, instagram: String, facebook: String, twitter: String, completion: @escaping(_ success:Bool, _ userData:Profile?)->()){
        
        
        self.isupdateUserLoading = true
        self.userRepo.updateUserDetails(name: name, username: username, instagram: instagram, facebook: facebook, twitter: twitter) { response in
            self.updateUser = response.responseData
            
            
            if(response.errorMessage != "" || !response.isSucess){
                self.updateUserResponseMessage = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.isupdateUserLoading = false
                    self.updateUserResponseMessage = ""
                   
                    completion(false,nil)

                    
                }
            } else {
                self.isupdateUserLoading = false
                completion(true,response.responseData!.user)
            }
        }
        
        
        
    }
    
    
    func updateProfilePicture(image: UIImage,completion: @escaping(_ success:Bool, _ data: ProfilePictureUpdateModel?)->()){
        self.imageUploadingLoading = true
        
        let targetURL = URL(string: "https://buzzmash.onrender.com/api/v1/user/profilePicture")!
        var request = URLRequest(url: targetURL)
        request.httpMethod = "POST"
        
        if let token = UserDefaults.standard.string(forKey: ApplicationText.token) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        guard let imageData = image.jpegData(compressionQuality: 1) else {
             completion(false, nil)
             return
         }
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"profilePicture\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(false, nil)
                    return
                }
                do {
                    // Decode the JSON data into the AddBlogThumbnail struct
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(ProfilePictureUpdateModel.self, from: data)
                    // Check for server-reported success
                    let isSuccess = responseData.success
                   

                    completion(isSuccess, responseData)
                    self.imageUploadingLoading = false
                } catch {

                    completion(false, nil)
                    self.imageUploadingLoading = false
                }
            }
        }.resume()


        
    }
    
    
    
}
