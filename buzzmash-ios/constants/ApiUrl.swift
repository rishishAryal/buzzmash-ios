//
//  ApiUrl.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation


class ApiUrl {
    
    
    static let  baseUrl = "https://buzzmash.onrender.com/api/v1/"
    
    static let getBlogCategory = baseUrl + "blog/getCategory"
    static let getBlogFeed = baseUrl + "blog/getAll"
    static let getUserBlogs = baseUrl + "blog/getUserBlogs"
    static let login = baseUrl + "user/login"
    static let register = baseUrl + "user/register"
    static let checkEmailExist = baseUrl + "user/checkEmail"
    static let checkUsernameExist = baseUrl + "user/checkUsername"
    static let changePassword = baseUrl + "user/changePassword"
    static let updateProfile = baseUrl + "user/updateProfile"
    static let fetchProfile = baseUrl + "user/profile"
    static let createBlog = baseUrl + "blog/create-blog"
    static let getBlogByCategory = baseUrl + "blog/getBlogByCategory"
    static let likeBlog = baseUrl + "blog/like"
    static let comment = baseUrl + "blog/comment"
   
    
}
