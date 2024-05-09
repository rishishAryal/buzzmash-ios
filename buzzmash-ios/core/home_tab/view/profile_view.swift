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
    var body: some View {
        NavigationStack{
            VStack {
                HStack{
                    Spacer()
                    Text("Profile").bold()
                        .padding(.leading,25)
                    Spacer()
                    
                    NavigationLink {
                        Settings().navigationTitle("Settings")
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
                            AsyncImage(url: URL(string: userVm.profile?.profile.profilePicture ?? "")) { image in
                                      image
                                          .resizable()
                                          .aspectRatio(contentMode: .fill)
                                          .frame(width: 70, height: 70)
                                          .clipShape(Circle())
                                          
                                  } placeholder: {
                                      Color.gray
                                          .frame(width: 70, height: 70)
                                          .clipShape(Circle())
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
               
               
                
                
                
                Spacer()
            }
        }
    }
}



