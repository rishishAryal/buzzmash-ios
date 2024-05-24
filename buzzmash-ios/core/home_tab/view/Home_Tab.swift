//
//  Home_Tab.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct HomeTab: View {
    @StateObject var blogVM:BlogViewModel = BlogViewModel(blogRepo: BlogApiServiceRepo(blogApiService: BlogApiService()))
    @EnvironmentObject var authVm: AuthViewModel
    @StateObject var searchVM:SearchViewModel = SearchViewModel(searchRepo: SearchUserRepo(searchUserService: SearchUserService()))
    @StateObject var followVM:FollowViewModel = FollowViewModel(followRepo: FollowServiceRepo(followService: FollowService()))
//    @StateObject var userVm:UserViewModel = UserViewModel(userRepo: UserApiServiceRepo(userServiceRepo: UserApiService()))
    @ObservedObject var userVm:UserViewModel
    
    func getProfilePictureLink()->String {
        
        
        if let profilePicture = UserDefaults.standard.string(forKey: "profilePicture") {
            return profilePicture
        } else {
            return ""
        }
        
        
    }

    
    var body: some View {
        
        
        if(authVm.showSplashScreen) {
            SplashScreen().environmentObject(authVm)
        } else {
            if (authVm.isUserLogin) {
                TabView {
                    FeedView(blogVM: blogVM, authVm: authVm)
                    .tabItem {
                        
                        VStack{
                            Image(systemName: "house")

                            Text("Home")
                        }
                    }
                    
                    SearchView( searchVM: searchVM, followVM: followVM, userVm: userVm )
                        .tabItem {
                            
                            VStack {
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                            }
                            
                        }
                    
                    VStack {
                        AddBlog(blogVM: blogVM)
                    }.tabItem {
                        Image(systemName: "plus")

                        Text("Blog")
                    }
                    profile_view(authVm: authVm, userVm: userVm, blogVM: blogVM, followVM: followVM)
                      
                .tabItem {
                
                                
                                        Image(systemName: "person")
                                            
                                        Text("Profile")
                                    
                                
                      
                    
                        
                    }
                    
                }.onAppear {
                    if (authVm.isUserLogin) {
                        
                    }
                }
            } else {
                login(userVM: userVm).environmentObject(authVm)
            }
        }
        
      
        
       
     
    }
}





