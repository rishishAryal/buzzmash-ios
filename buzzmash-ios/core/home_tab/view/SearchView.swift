//
//  SearchView.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

import SwiftUI

struct SearchView: View {
    @State var search:String = ""
    @State var ex:String = ""
    @ObservedObject var searchVM:SearchViewModel
    @ObservedObject var followVM:FollowViewModel
    @ObservedObject var userVm: UserViewModel
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView{
                    if searchVM.isLoading {
                        ProgressView()
                    } else {
                        ForEach(searchVM.requiredSearchuser, id: \.id){user in
                        
                            HStack {
                                if !user.profilePicture.isEmpty {
                                    AsyncImage(url: URL(string: user.profilePicture)) { image in
                                              image
                                                  .resizable()
                                                  .aspectRatio(contentMode: .fill)
                                                  .frame(width: 50, height: 50)
                                                  .clipShape(Circle())
                                                  
                                          } placeholder: {
                                              ShimmerEffectBox()
                                                  .frame(width: 50, height: 50)
                                                  .clipShape(Circle())
                                          }
                                    
                                } else {
                                    AsyncImage(url: URL(string: "https://st4.depositphotos.com/9998432/22597/v/450/depositphotos_225976914-stock-illustration-person-gray-photo-placeholder-man.jpg")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ShimmerEffectBox()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    }

                                }
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                    Text(user.name).font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                
                                
                                Spacer()
                                if user.isFollowing {
                                    Text("unfollow")
                                        .foregroundStyle(.white)
                                        .padding(5)
                                        .background(.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        .onTapGesture {
                                        followVM.unfollow(following: user.id) { isSucess in
                                            if isSucess {
                                                let index = searchVM.requiredSearchuser.firstIndex(where: {
                                                    $0.id == user.id
                                                })
                                                
                                                if let i = index {
                                                    searchVM.requiredSearchuser[i].isFollowing = false
                                                }
                                                userVm.profile?.profile.followingCount = (userVm.profile?.profile.followingCount)! - 1
                                                
                                            }
                                        }
                                    }
                                } else {
                                    Text("follow")
                                        .foregroundStyle(.white)
                                        .padding(5)
                                        .background(.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .onTapGesture {
                                        followVM.follow(following: user.id) { isSuccess in
                                            if isSuccess {
                                                let index = searchVM.requiredSearchuser.firstIndex(where: {
                                                    $0.id == user.id
                                                })
                                                
                                                if let i = index {
                                                    searchVM.requiredSearchuser[i].isFollowing = true
                                                }
                                                userVm.profile?.profile.followingCount = (userVm.profile?.profile.followingCount)! + 1
                                            }
                                        }
                                    }
                                }
                                
                               
                            }.padding(.horizontal)
                            
                            
                        }
                    }
                }
            }
            
            
        }.searchable(text: $search).onSubmit(of: .search) {
            searchVM.searchUser(search: String(search)) { isSuccess in
                
            }
        }
      
    }
}

