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
    static let getBlogFeed = baseUrl + "blog/getBlogFeed"
    static let login = baseUrl + "user/login"
    static let fetchProfile = baseUrl + "user/profile"
    static let createBlog = baseUrl + "blog/create-blog"
    
    
}
