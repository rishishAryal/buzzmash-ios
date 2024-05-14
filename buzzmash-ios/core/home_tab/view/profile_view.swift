//
//  profile_view.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct profile_view: View {
    @ObservedObject var authVm: AuthViewModel
    @StateObject var userVm:UserViewModel = UserViewModel(userRepo: UserApiServiceRepo(userServiceRepo: UserApiService()))
    @ObservedObject var blogVM:BlogViewModel
    @State var showingImagePicker:Bool = false
    @State private var inputImage: UIImage?
    @State private var imageToShow: Image?
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack{
                    Spacer()
                    Text("Profile").bold()
                        .padding(.leading,25)
                    Spacer()
                    
                    NavigationLink {
                        Settings(authVm: authVm, userVM: userVm, blogVM: blogVM).navigationTitle("Settings")
                    } label: {
                        Image(systemName: "gear").font(.title)
                        

                    }

                    
                }.padding(.horizontal)
             
                
                if userVm.isLoading {
                    HStack{
                        VStack (alignment: .leading, spacing: 20){
                            Color.gray
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading){
                                   Text("")
                                    Text( "").font(.footnote).foregroundStyle(.gray)
                                Text( "").font(.footnote).foregroundStyle(.gray)

                                        .fontWeight(.light)
                               }
                            
                            
                            

                            
                           
                            
                        }
                        Spacer()
                    }.padding().background(.gray.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    HStack{
                        VStack (alignment: .leading, spacing: 20){
                            HStack(spacing: 20){
                                AsyncImage(url: URL(string: userVm.profile?.profile.profilePicture ?? "https://st4.depositphotos.com/9998432/22597/v/450/depositphotos_225976914-stock-illustration-person-gray-photo-placeholder-man.jpg")) { image in
                                          image
                                              .resizable()
                                              .aspectRatio(contentMode: .fill)
                                              .frame(width: 70, height: 70)
                                              .clipShape(Circle()).overlay(alignment: .bottomTrailing) {
                                                  Image(systemName: "camera.fill").font(.caption2).foregroundStyle(.white)
                                                      .padding(6).background(.gray).clipShape(Circle())
                                                      
                                              }
                                              
                                      } placeholder: {
                                          Color.gray
                                              .frame(width: 70, height: 70)
                                              .clipShape(Circle())
                                      }
                                
                                      .onTapGesture(perform: {
                                          showingImagePicker.toggle()
                                      })
                                
                                      .sheet(isPresented: $showingImagePicker) {
                                                ImagePicker(image: $inputImage, imageToShow: $imageToShow)
                                            }
                                
                                if let img = inputImage {
                                    
                                    
                                    if (userVm.imageUploadingLoading) {
                                        ProgressView()
                                    } else {
                                        Text("Update").onTapGesture {
                                            userVm.updateProfilePicture(image: img) { success, data in
                                                if success {
                                                    withAnimation {
                                                        userVm.profile?.profile.profilePicture = data!.profilePicture

                                                    }
                                                inputImage = nil

                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                    
//                                    Button(action: {
//                                        userVm.updateProfilePicture(image: img) { success, data in
//                                            if success {
//                                                userVm.profile?.profile.profilePicture = data!.profilePicture
//                                                
//                                            }
//                                    }, label: {
//                                        if userVm.imageUploadingLoading {
//                                            ProgressView()
//                                        } else {
//                                            Text("Update")
//                                        }
//                                    })
//                                    
//                                    }
                                }
                                Spacer()
                            }

                            VStack(alignment: .leading){
                                   Text(userVm.profile?.profile.username ?? "")
                                    Text(userVm.profile?.profile.name ?? "").font(.footnote).foregroundStyle(.gray)
                                Text(userVm.profile?.profile.email ?? "").font(.footnote).foregroundStyle(.gray)

                                        .fontWeight(.light)
                               }
                            
                            
                            

                            
                           
                            
                        }
                        Spacer()
                    }.padding().background(.gray.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 10))
                }
               
               
                NavigationLink {
                    DashboardView(userVm: userVm, blogVM: blogVM).navigationTitle("Dashboard")
                } label: {
                    HStack {
                        Image(systemName: "list.dash.header.rectangle")
                        Text("Dashboard")
                        Spacer()
                    }.padding().foregroundStyle(.gray)
                }

                
             
                
                
                Spacer()
            }
        }
    }
}



struct DashboardView:View {
    @ObservedObject var userVm:UserViewModel
    @State var showDeleteAlert : Bool = false
    @State var blogID:String = ""
    @ObservedObject var blogVM:BlogViewModel
    @State var thumbnail:String = ""

    func convertToDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")  // Set to POSIX to avoid any locale-specific issues.
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)      // Optional: Adjust time zone if necessary.
        return dateFormatter.date(from: dateString)
    }
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                if(userVm.getBlogDashboardIsLoading) {
                    
                } else {
                    ScrollView {
                        ForEach(userVm.requiredBlogDashboard.sorted(by: {convertToDate(from: $0.createdAt)! > convertToDate(from: $1.createdAt)! }), id: \.id) {blog in
                            HStack {
                                if(!blog.thumbnail.isEmpty) {
                                    AsyncImage(url: URL(string: blog.thumbnail)) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                        
                                    } placeholder: {
                                        Rectangle().foregroundStyle(.gray.opacity(0.2)) .frame(width: 100, height: 100)
                                    }
                                }
                            

                                Text(blog.title.prefix(50))
                                Spacer()
                                HStack {
                                    Button {
                                        blogID = blog.id
                                        thumbnail = blog.thumbnail
                                        withAnimation {
                                            showDeleteAlert = true

                                        }
                                    
                                    } label: {
                                        Text("Delete").foregroundStyle(.white).padding(7).background(.red).clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    
                                    NavigationLink {
//                                        EditBlogView(blogVM: blogVM)
                                        
                                        EditBlogView(title: blog.title, desc: blog.description, category: blog.category, thumbnail: blog.thumbnail, author: blog.author, blogID: blog.id, blogVM: blogVM, onThumbnailUpdate: {imgUrl, blogId in
                                          
                                            let index = userVm.requiredBlogDashboard.firstIndex(where: {$0.id == blogId})
                                            
                                            if let i = index {
                                                userVm.requiredBlogDashboard[i].thumbnail = imgUrl
                                            }
                                           
                                            
                                        }, onBlogUpdate:
                                                        {
                                            data, blogId in
                                            
                                            let blog = userVm.requiredBlogDashboard.firstIndex(where: {$0.id == blogId})
                                            
                                            if let index = blog {
                                                userVm.requiredBlogDashboard[index].thumbnail = data.updatedBlog.thumbnail
                                                userVm.requiredBlogDashboard[index].title = data.updatedBlog.title
                                                userVm.requiredBlogDashboard[index].author = data.updatedBlog.author
                                                userVm.requiredBlogDashboard[index].category = data.updatedBlog.category
                                                userVm.requiredBlogDashboard[index].description = data.updatedBlog.description




                                            }
                                         
                                            
                                        })
                                        .navigationTitle("Edit Blog")
                                    } label: {
                                        Text("Edit").foregroundStyle(.white).padding(7).background(.green).clipShape(RoundedRectangle(cornerRadius: 10))

                                    }

                                  

                                }
                                
                            }.padding(.horizontal)
                        }
                      
                    }.refreshable {
                        userVm.getUserDasboardBlogs { Bool in
                            
                        }
                    }
                }
                
                
                
                Spacer()
            }
        }
        
        .overlay(content: {
            if showDeleteAlert {
                VStack(spacing: 20) {
                    Text("Do you want to delete this blog?").bold()
                    
                    HStack(spacing: 20)  {
                        Text("NO").bold()
                            .onTapGesture {
                                withAnimation {
                                    showDeleteAlert = false

                                }
                            }
                        Text("YES").bold().foregroundStyle(.red).onTapGesture {
                            userVm.deleteBlog(id:blogID) { isSuccess in
                                if isSuccess {
                                  
                                    let index = userVm.requiredBlogDashboard.firstIndex(where: {$0.id == blogID})
                                    
                                    if let i = index {
                                        userVm.requiredBlogDashboard.remove(at: i)
                                    }
                                 
                                
                                    withAnimation {
                                        showDeleteAlert = false

                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                }.padding().background(.gray).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 15))
            }
        })
        
        .onAppear {
            if !userVm.isDashboardCalled {
                userVm.getUserDasboardBlogs { isSuccess in
                    
                }
            }
           
        }
    }
}
