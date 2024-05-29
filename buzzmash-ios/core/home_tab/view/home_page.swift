//
//  home_page.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct FeedView:View {
    @ObservedObject var blogVM:BlogViewModel
    @State var selectedId:String = "All"
    @Namespace var namesapce
    @ObservedObject var authVm: AuthViewModel
    @State var isFollowingFeed:Bool = false
    
    var appInitVM:AppInitVM = AppInitVM.appInitVM
    
     // This ensures the date format is interpreted correctly
    
    func convertToDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")  // Set to POSIX to avoid any locale-specific issues.
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)      // Optional: Adjust time zone if necessary.
        return dateFormatter.date(from: dateString)
    }

    
    
    func formatDateString(_ dateString: String) -> String {
        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()

        // Set the input format to match the given date string
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        // Parse the given date string
        if let date = dateFormatter.date(from: dateString) {
            // Set the output format
            dateFormatter.dateFormat = "MMM d, yyyy"
            
            // Format the date
            let formattedDate = dateFormatter.string(from: date)
            
            // Return the formatted date
            return formattedDate
        } else {
            return "Invalid date format"
        }
    }
    
    @Namespace var namespace
    @State var selected:String = "Explore"
    var body: some View {
        NavigationStack{
            VStack {
                HStack{
                    Spacer()
                    Text("Following").foregroundStyle(.text).padding(5)
                        .onTapGesture {
                            if let feed = blogVM.followingFeedMap["feed"] {
                                blogVM.requiredFollowingFeed = feed
                            } else {
                                blogVM.getFeedOfFollowing()
                            }
                            withAnimation {
                                isFollowingFeed = true
                            }
                           
                            
                        }
                        .overlay(alignment: .bottom) {
                            if isFollowingFeed {
                                Rectangle().frame(height: 1).foregroundStyle(.text)
                                    .matchedGeometryEffect(id: "id", in: namesapce)

                            }
                        }
                        
                    
                    
                    Rectangle().frame(width: 1, height: 10)
                    Text("Explore").foregroundStyle(.text).padding(5)
                        .onTapGesture {
                            withAnimation {
                                isFollowingFeed = false
                            }
                       
                    }
                        .overlay(alignment: .bottom) {
                            if !isFollowingFeed {
                                Rectangle().frame(height: 1).foregroundStyle(.text)
                                    .matchedGeometryEffect(id: "id", in: namesapce)
                            }
                        }
                    Spacer()
                }
                
                if isFollowingFeed {
                    if (blogVM.followingFeedIsLoading) {
                        FeedShimmer()
                    } else {
                        ScrollView{
                            ForEach(blogVM.requiredFollowingFeed.sorted(by: {convertToDate(from: $0.createdAt)! > convertToDate(from: $1.createdAt)! }), id: \.id){blog in
                                
                                NavigationLink {
                                    DetailBlog(blogId: blog.id, profileImage: blog.authorProfile, author: blog.author, date: formatDateString(blog.createdAt), category: blog.category, title: blog.title, desc: blog.description, thumbnail: blog.thumbnail, blogVM: blogVM)
                                } label: {
                                    
                                    FeedItem(authorProfile: blog.authorProfile, author: blog.author, category: blog.category, createdAt: blog.createdAt, blogId: blog.id, blogVM: blogVM, hasLiked: blog.hasLiked, likeCount: blog.likeCount, title: blog.title, thumbnail: blog.thumbnail)
                                }
                                
                                
                                
                                
                            }
                        }.refreshable {
                            blogVM.getFeedOfFollowing()
                        }
                    }
                } else {
                    VStack{
                        if(appInitVM.getBlogCategoryIsLoading) {
                            CategoryShimmer()
                        } else {
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                
                                HStack {
                                    VStack(spacing: 5) {
                                        Text("All").bold()
                                        if (selectedId == "All"){
                                            Rectangle().frame(height: 3)
                                                .foregroundStyle(.green).matchedGeometryEffect(id: "category", in: namesapce)
                                        }
                                        else {
                                            Rectangle().frame(height: 3) .foregroundStyle(.clear)
                                        }
                                        
                                    }.onTapGesture(perform: {
                                        withAnimation {
                                            selectedId = "All"
                                            
                                            if let feed = blogVM.categoryFeedMap[selectedId] {
                                                if feed.isEmpty {
                                                    blogVM.getFeed { Bool in
                                                        
                                                    }
                                                } else {
                                                    blogVM.requiredBlogFeed = feed

                                                }
                                            } else {
                                                blogVM.getFeed { Bool in
                                                    
                                                }
                                            }
                                           
                                           
                                        }
                                       
                                    })
                                    ForEach(appInitVM.requiredBlogCategory, id: \.id){cat in
                                        
                                        
                                        
                                        VStack(spacing: 5) {
                                            Text(cat.name).bold()
                                            if (selectedId == cat.name){
                                                Rectangle().frame(height: 3)
                                                    .foregroundStyle(.green).matchedGeometryEffect(id: "category", in: namesapce)
                                            }
                                            else {
                                                Rectangle().frame(height: 3) .foregroundStyle(.clear)
                                            }
                                            
                                        }
                                        .onTapGesture(perform: {
                                            withAnimation {
                                                selectedId = cat.name
                                                
                                                if let feed = blogVM.categoryFeedMap[cat.name] {
                                                    if feed.isEmpty {
                                                        blogVM.getFeedByCategory(category: cat.name) { Bool in
                                                            
                                                        }
                                                    } else {
                                                        blogVM.requiredBlogFeed = feed
                                                    }
                                                } else {
                                                    blogVM.getFeedByCategory(category: cat.name) { Bool in
                                                        
                                                    }
                                                }
                                              

                                            }
                                        })
                                        
                                        
                                       
                                       
                                    }
                                }.padding()
                               
                            }.padding().background(.gray.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
                          
                        }
                       
                            if (blogVM.getBlogFeedIsLoading){
                                     FeedShimmer()
                            } else {
                               
                                ScrollView {
                                    
                                    if blogVM.requiredBlogFeed.count == 0 {
                                        Text("No Blog of this category").padding(.top,50)
                                    }
                                    
                                    ForEach(blogVM.requiredBlogFeed.sorted(by: {convertToDate(from: $0.createdAt)! > convertToDate(from: $1.createdAt)! }), id: \.id) {blog in
                                        
                                      
                                        
                                        NavigationLink {
                                            DetailBlog(blogId: blog.id, profileImage: blog.authorProfile, author: blog.author, date: formatDateString(blog.createdAt), category: blog.category, title: blog.title, desc: blog.description, thumbnail: blog.thumbnail, blogVM: blogVM)
                                        } label: {
                                            
                                            
                                            FeedItem(authorProfile: blog.authorProfile, author: blog.author, category: blog.category, createdAt: blog.createdAt, blogId: blog.id, blogVM: blogVM, hasLiked: blog.hasLiked, likeCount: blog.likeCount, title: blog.title, thumbnail: blog.thumbnail)
                                            

                                        }

                                        
                                  
                                            
                                        

                                        
                                        
                                    }
                                }
                                
                                
                                .refreshable {
                                    if selectedId == "All"
                                    {
                                        blogVM.getFeed { Bool in
                                            
                                        }
                                    } else {
                                        blogVM.getFeedByCategory(category: selectedId) { _ in
                                            
                                        }
                                    }
                                   
                                }
                            }
                        
                        
                Spacer()
                        
                    }.onAppear {
                        if (authVm.isUserLogin)
                        {
                            if !blogVM.feedApiHited {
                                blogVM.getFeed() {_ in
                                    
                                    
                                }
                            }
                        }
                     
                      
                    }
                }
                
           
                Spacer()
            }
        }

    }
  
}
