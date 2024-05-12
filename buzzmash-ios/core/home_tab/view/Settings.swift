//
//  Settings.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct Settings: View {
    @ObservedObject var authVm: AuthViewModel
    @ObservedObject var userVM:UserViewModel


    var body: some View {
        NavigationStack{
            VStack {
                
                List {
                    
                    NavigationLink {
                        EditProfile(authVm: authVm, userVM: userVM).navigationTitle("Edit Profile")
                    } label: {
                        HStack(spacing: 20){
                            Image(systemName: "pencil")
                            Text("Edit Profile")
                            Spacer()
                    
                        }
                    }

                 
                    
                    
                    HStack(spacing: 20) {
                        Image(systemName: "door.sliding.right.hand.open")
                        Text("Logout")
                        Spacer()
                            
                    }.contentShape(RoundedRectangle(cornerRadius: 10))

                    .onTapGesture {
                            authVm.logout()
                        
                    }
                }.listStyle(.automatic)
               
               
                Spacer()
            }
        }
        
        
    }
}


struct EditProfile:View {
    @ObservedObject var authVm: AuthViewModel
    @ObservedObject var userVM:UserViewModel

    var body: some View {
        NavigationStack{
            VStack {
                
                List {
                    
                    NavigationLink {
                        ChangePassword(authVm: authVm).navigationTitle("Change Password")
                    } label: {
                        HStack(spacing: 20){
                            Image(systemName: "person.badge.key.fill")
                            Text("Change password")
                            Spacer()
                    
                        }
                    }

                    
                    NavigationLink {
                        EditUserDetails(userVM: userVM).navigationTitle("Change User Details")
                    } label: {
                        HStack(spacing: 20){
                            Image(systemName: "note.text")
                            Text("Edit User Details")
                            Spacer()
                    
                        }
                    }
                    

                
                }.listStyle(.automatic)
               
               
                Spacer()
            }
        }

    }
}


struct ChangePassword:View {
    @ObservedObject var authVm: AuthViewModel
    @State var oldPassword:String = ""
    @State var newPassword:String = ""
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State var alertColor:Color = .green
    var body: some View {
        VStack {
            TextField("Enter Old Password", text: $oldPassword)
                .textFieldStyle(.roundedBorder)
            TextField("Enter New Password", text: $newPassword)
                .textFieldStyle(.roundedBorder)
            Text(alertMessage).foregroundStyle(alertColor)
            
            RoundedRectangle(cornerRadius: 10).frame(height: 50).foregroundStyle(.blue)
                .onTapGesture(perform: {
                    authVm.changePassword(oldPassword: oldPassword, newPassword: newPassword) { isSuccess in
                        if isSuccess {
                            showAlert = true
                            alertMessage = "Password Changed"
                            alertColor = .green
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                showAlert = false
                                alertMessage = ""
                                alertColor = .green
                            }
                        } else {
                            showAlert = true
                            alertMessage = "Something went worng"
                            alertColor = .red
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                showAlert = false
                                alertMessage = ""
                                alertColor = .green
                            }

                        }
                        
                   
                       
                    }
                })
            
            
          
                
                .overlay {
                if authVm.isChangePasswordLoading {
                    ProgressView()
                } else {
                    Text("Change Password").foregroundStyle(.white)

                }
            }
            Spacer()
        }.padding()
    }
}


struct EditUserDetails:View {
    @ObservedObject var userVM:UserViewModel

    @State var name:String = ""
    @State var username:String = ""
    @State var insta:String = ""
    @State var twitter:String = ""
    @State var facebook:String = ""
    
    @State var showAlert:Bool = false
    @State var alertMessage:String = "User details update"
    @State var alertColor:Color = .green
    
    var body: some View {
        VStack{
            VStack {
                VStack(alignment: .leading){
                    Text("Name").font(.caption)
                    TextField("Enter name", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading)  {
                    Text("Username").font(.caption)
                    TextField("Enter username", text: $username)
                        .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading){
                    Text("Instagram").font(.caption)
                    TextField("Enter instagram link", text: $insta)
                        .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading){
                    Text("Twitter").font(.caption)
                    TextField("Enter twitter link", text: $twitter)
                        .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading){
                    Text("Facebook").font(.caption)
                    TextField("Enter facebook link", text: $facebook)
                        .textFieldStyle(.roundedBorder)
                }
                if showAlert {
                    Text(alertMessage).foregroundStyle(alertColor)

                }
                
                RoundedRectangle(cornerRadius: 10).foregroundStyle(.blue).frame(height: 50)
                    .onTapGesture(perform: {
                        userVM.updateUserDetail(name: name, username: username, instagram: insta, facebook: facebook, twitter: twitter) { success, userData in
                            if success {
                                userVM.profile!.profile = userData!
                                
                                showAlert = true
                                alertMessage = "User details update"
                                alertColor = .green
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                    showAlert = false
                                    alertMessage = ""
                                    alertColor = .green
                                }
                                
                            } else {
                                showAlert = true
                                alertMessage = "Something went worng"
                                alertColor = .red
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                    showAlert = false
                                    alertMessage = ""
                                    alertColor = .green
                                }
                            }
                        }
                    })
                    .overlay {
                    if userVM.isupdateUserLoading {
                        ProgressView()
                    } else {
                        Text("Update Details").foregroundStyle(.white)

                    }
                }
                
              
            }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
            Spacer()
        }.onAppear(perform: {
            name = userVM.profile?.profile.name ?? ""
            username = userVM.profile?.profile.name ?? ""
            insta = userVM.profile?.profile.instagram ?? ""
            twitter = userVM.profile?.profile.twitter ?? ""
            facebook = userVM.profile?.profile.facebook ?? ""
            
        })
    }
}
