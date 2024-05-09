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

    
    var body: some View {
        
        
        if(authVm.showSplashScreen) {
            SplashScreen()
        } else {
            if (authVm.isUserLogin) {
                TabView {
                    FeedView(blogVM: blogVM)
                    .tabItem {
                        
                        VStack{
                            Image(systemName: "house")

                            Text("Home")
                        }
                    }
                    VStack {
                        AddBlog(blogVM: blogVM)
                    }.tabItem {
                        Image(systemName: "plus")

                        Text("Blog")
                    }
                                            profile_view(authVm: authVm)
                      
                .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }
            } else {
                login().environmentObject(authVm)
            }
        }
        
      
        
       
     
    }
}

#Preview {
    HomeTab()
}




