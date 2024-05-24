//
//  register.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct register: View {
    @State var email:String = ""
    @State var password:String = ""
    @State var name:String = ""
    @State var username:String = ""
    @State private var birthDate = Date.now
    @ObservedObject var authVm:AuthViewModel
    @ObservedObject var userVM:UserViewModel
    
    @State var showUsernameExistAlert:Bool = false
    @State var showEmailExistAlert:Bool = false
    
    @State var ifUsernameExist:Bool = false
    @State var ifEmailExist:Bool = false
    


    var body: some View {
        
        VStack {
            HStack{
                Text("Register")
                    .font(.title).bold()
            }
            VStack(spacing: 20){
      
             
                TextField("Enter Name", text: $name)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal)
                TextField("Enter Username", text: $username)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal).onChange(of: username) {newVal in
                        
                        if newVal.count>3 {
                            authVm.checkUsername(username: newVal) { isAvailable, isSuccess in
                                if isSuccess {
                                    showUsernameExistAlert = true
                                    ifUsernameExist = isAvailable
                                    
                                }
                            }
                            
                            
                        } else {
                            showUsernameExistAlert = false
                        }
                        
                    }
                if showUsernameExistAlert {
                    Text(ifUsernameExist ?  "You can use this username!" : "You cannot use this username!")
                        .foregroundStyle(ifUsernameExist ? .green : .red )
                }
                TextField("Enter Email", text: $email)
                    .padding(7)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal)
                    .onChange(of: email) { newVal in
                        
                        if newVal.count>3 {
                            authVm.checkEmail(email: newVal) { isAvailable, isSuccess in
                                if isSuccess {
                                    showEmailExistAlert = true
                                    ifEmailExist = isAvailable
                                    
                                }
                            }
                            
                            
                        } else {
                            showEmailExistAlert = false
                        }
                    }
                if showEmailExistAlert {
                    Text(ifEmailExist ?  "You can use this email!" : "You cannot use this email!")
                        .foregroundStyle(ifEmailExist ? .green : .red )
                }
                
                DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) {
                             Text("Birth Date")
                        .padding(.horizontal)
                         }
                
//                Text("Date is \(birthDate.toFormattedString())")

                TextField("Enter Password", text: $password)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal)
                
                Button(action: {
                    authVm.registerUser(email: email, password: password, name: name, username: username, DOB: birthDate.toFormattedString()) {isSuccess in
                        
                        userVM.getUserProfile()
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 10).frame(height: 40).padding(.horizontal)
                        .overlay {
                            if authVm.isRegisterLoading {
                                ProgressView()
                            } else {
                                Text("Register").foregroundStyle(.white).bold()

                            }
                        }
                    
                })
            }
            
            
                
            
            Spacer()
        }
    }
}



extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
