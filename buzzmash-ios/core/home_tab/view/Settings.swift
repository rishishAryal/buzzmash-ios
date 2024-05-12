//
//  Settings.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct Settings: View {
    @ObservedObject var authVm: AuthViewModel

    var body: some View {
        NavigationStack{
            VStack {
                
                List {
                    
                    NavigationLink {
                        EditProfile(authVm: authVm).navigationTitle("Edit Profile")
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
                        ChangePassword(authVm: authVm).navigationTitle("Change User Details")
                    } label: {
                        HStack(spacing: 20){
                            Image(systemName: "person.badge.key.fill")
                            Text("Change User Details")
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
