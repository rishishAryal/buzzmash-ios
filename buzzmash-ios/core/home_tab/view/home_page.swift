//
//  home_page.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct FeedView:View {
    @ObservedObject var blogVM:BlogViewModel
    @State var selectedId:String = "all"
    @Namespace var namesapce
    @ObservedObject var authVm: AuthViewModel
    
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
    
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack{
                    Spacer()
                    Text("Buzzmash")
                    Spacer()
                }
                if(appInitVM.getBlogCategoryIsLoading) {
                    ProgressView()
                } else {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        
                        HStack {
                            VStack(spacing: 5) {
                                Text("All").bold()
                                if (selectedId == "all"){
                                    Rectangle().frame(height: 3)
                                        .foregroundStyle(.green).matchedGeometryEffect(id: "category", in: namesapce)
                                }
                                else {
                                    Rectangle().frame(height: 3) .foregroundStyle(.clear)
                                }
                                
                            }.onTapGesture(perform: {
                                withAnimation {
                                    selectedId = "all"
                                    blogVM.getFeed { Bool in
                                        
                                    }
                                }
                               
                            })
                            ForEach(appInitVM.requiredBlogCategory, id: \.id){cat in
                                
                                
                                
                                VStack(spacing: 5) {
                                    Text(cat.name).bold()
                                    if (selectedId == cat.id){
                                        Rectangle().frame(height: 3)
                                            .foregroundStyle(.green).matchedGeometryEffect(id: "category", in: namesapce)
                                    }
                                    else {
                                        Rectangle().frame(height: 3) .foregroundStyle(.clear)
                                    }
                                    
                                }
                                .onTapGesture(perform: {
                                    withAnimation {
                                        selectedId = cat.id
                                        blogVM.getFeedByCategory(category: cat.name) { Bool in
                                            
                                        }

                                    }
                                })
                                
                                
                               
                               
                            }
                        }.padding()
                       
                    }.padding().background(.gray.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
                  
                }
               
                    if (blogVM.getBlogFeedIsLoading){
                        ProgressView()
                    } else {
                       
                        ScrollView {
                            
                            if blogVM.requiredBlogFeed.count == 0 {
                                Text("No Blog of this category").padding(.top,50)
                            }
                            
                            ForEach(blogVM.requiredBlogFeed.sorted(by: {convertToDate(from: $0.createdAt)! > convertToDate(from: $1.createdAt)! }), id: \.id) {blog in
                                
                              
                                
                                NavigationLink {
//                                    DetailBlog(blogId: blog.id, profileImage: blog.authorProfile, author: blog.author, date: formatDateString(blog.createdAt), category: blog.category, title: blog.title, desc: blog.description ,blogVM: blogVM)
                                    
                                    DetailBlog(blogId: blog.id, profileImage: blog.authorProfile, author: blog.author, date: formatDateString(blog.createdAt), category: blog.category, title: blog.title, desc: blog.description, thumbnail: blog.thumbnail, blogVM: blogVM)
                                } label: {
                                    VStack {
                                        HStack {
                                         
                                               
                                                if !blog.authorProfile.isEmpty {
                                                    AsyncImage(url: URL(string: blog.authorProfile)) { image in
                                                              image
                                                                  .resizable()
                                                                  .aspectRatio(contentMode: .fill)
                                                                  .frame(width: 15 ,height: 15)
                                                                  .clipShape(Circle())
                                                                  
                                                          } placeholder: {
                                                              Color.gray
                                                                  .frame(width: 15, height: 15)
                                                                  .clipShape(Circle())
                                                          }
                                                          
                                                }

                                                Text(" By \(blog.author)").font(.footnote)
                                            Text("in").font(.footnote).fontWeight(.light).foregroundStyle(.gray)
                                            Text("\(blog.category)").font(.footnote)

                                                
                                            
                                            
                                            Spacer()
                                            Text(formatDateString(blog.createdAt)).foregroundStyle(.gray).font(.footnote)
                                            
                                        }.padding(.horizontal)
                                        
                                        
                                   
                                        HStack {
                                            Button {
                                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                                blogVM.likeunlikeBlog(blogId: blog.id) { success in
                                                    if success {
                                                        if let index = blogVM.requiredBlogFeed.firstIndex(where: { $0.id == blog.id }) {
                                                            blogVM.requiredBlogFeed[index].hasLiked.toggle()
                                                            blogVM.requiredBlogFeed[index].likeCount += (blogVM.requiredBlogFeed[index].hasLiked ? 1 : -1)
                                                        }
                                                    }
                                                }
                                            } label: {
                                                
                                                VStack(alignment: .center){
                                                    Image(systemName: blog.hasLiked ? "arrowshape.up.fill" : "arrowshape.up").foregroundStyle(blog.hasLiked ? .red : .gray).font(.footnote)
                                                    Text("\(blog.likeCount)").foregroundStyle(.gray).font(.footnote)
                                                }
                                            }
                                            Text(blog.title).bold().multilineTextAlignment(.leading)
                                            
                                           Spacer()
                                            
                                            if !blog.thumbnail.isEmpty {
                                                AsyncImage(url: URL(string: blog.thumbnail)) { image in
                                                          image
                                                              .resizable()
                                                              .aspectRatio(contentMode: .fill)
                                                              .frame(width: 50, height: 50)
                                                              .clipShape(Rectangle())
                                                              
                                                      } placeholder: {
                                                          Color.gray
                                                              .frame(width: 50, height: 50)
                                                      }
                                                      
                                            } else {
                                                Color.clear
                                                    .frame(width: 50, height: 50)
                                            }
                                        }.padding(.horizontal)
                                   
                                      
                                        
                            
                                        
                                    }.foregroundStyle(Color.text).padding(.vertical).overlay(alignment: .bottom) {
                                        Rectangle().frame( height: 1).foregroundStyle(.gray.opacity(0.5))
                                    }
                                }

                                
                          
                                    
                                

                                
                                
                            }
                        }
                        
                        
                        .refreshable {
                            blogVM.getFeed { Bool in
                                
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

    }
  
}
