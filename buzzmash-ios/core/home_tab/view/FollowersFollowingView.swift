//
//  FollowersFollowingView.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

import SwiftUI

struct FollowersFollowingView: View {
    
    enum SelectedTab {
        case following
        case followers
    }
    @ObservedObject var followVM:FollowViewModel
    @State  var selected: SelectedTab
    @Namespace var namespace
    @Environment (\.dismiss) var dissmiss
    @State var newSelected:SelectedTab = .following
    var body: some View {
        
        VStack {
            VStack{
                HStack {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }.onTapGesture {
                        dissmiss.callAsFunction()
                    }
                    Spacer()
                }.padding(.horizontal).padding(.bottom,5)
                HStack (spacing: UIScreen.main.bounds.width/2){
                    
                    
                    Text("Followings").foregroundStyle(newSelected == .following ? .blue : .text).onTapGesture {
                        withAnimation {
                            newSelected = .following
                            selected = .following
                        }
                    }
                    .overlay(alignment: .bottom) {
                        if newSelected == .following {
                            Rectangle().frame(width: UIScreen.main.bounds.width/2,height: 1).foregroundStyle(.blue).offset(y:10)
                                .matchedGeometryEffect(id: "id", in: namespace)
                        }
                    }
                    
                    
                    
                    Text("Followers").foregroundStyle(newSelected == .followers ? .blue : .text).onTapGesture {
                        withAnimation {
                            newSelected = .followers
                            selected = .followers
                        }
                    }
                    .overlay(alignment: .bottom) {
                        if newSelected == .followers {
                            Rectangle().frame(width: UIScreen.main.bounds.width/2,height: 1).foregroundStyle(.blue).offset(y:10)
                                .matchedGeometryEffect(id: "id", in: namespace)
                        }
                    }
                    
                    
                }
            } .onChange(of: selected) { oldValue, newValue in
                withAnimation {
                    newSelected = newValue
                }
            }
            TabView(selection: $selected) {
                FollowingView(followVM: followVM)
                    .tag(SelectedTab.following)
                FollowerView(followVM: followVM)
                    .tag(SelectedTab.followers)
            }.onAppear(perform: {
                newSelected = selected
            })
        }
      
       
               
        
        .tabViewStyle(.page)
    }
}



struct FollowingView:View {
    @ObservedObject var followVM:FollowViewModel
    var body: some View {
        VStack{
            ScrollView {
                if followVM.followingLoading {
                    ProgressView()
                } else {
                    ForEach(followVM.requiredFollowingData, id: \.id) {following in
                        HStack {
                            ImageComponentwithText(name: following.profilePicture, image: following.profilePicture, height: 40, width: 40, fontsize: 30)
                            Text(following.username)
                            Spacer()
                        }
                        
                        
                       
                    }.padding(.horizontal)
                }
                
            }.refreshable {
                followVM.getFollowings()
            }
            Spacer()
        }.padding(.top).onAppear {
            if let following = followVM.followingMap["following"] {
                followVM.requiredFollowingData = following
            } else
            {
                followVM.getFollowings()
            }
            
        }
    }
}

struct FollowerView:View {
    @ObservedObject var followVM:FollowViewModel
    var body: some View {
        VStack{
            ScrollView {
                if followVM.followerLoading {
                    ProgressView()
                } else {
                    ForEach(followVM.requiredFollowerData, id: \.id) {follower in
                        HStack{
                            ImageComponentwithText(name: follower.username, image: follower.profilePicture, height: 40, width: 40, fontsize: 30)
                            Text(follower.username)
                            Spacer()
                        }.padding(.horizontal)
                        
                    }
                }
            }.refreshable {
                followVM.getFollowers()
            }
            Spacer()
        }.padding(.top).onAppear {
            if let follower = followVM.followerMap["follower"] {
                followVM.requiredFollowerData = follower
            } else {
                followVM.getFollowers()
            }
            
        }
    }
}
