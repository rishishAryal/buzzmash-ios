//
//  login.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct login: View {
    @State var email:String = ""
    @State var password:String = ""
    @EnvironmentObject var authVm:AuthViewModel
    var body: some View {
        
        VStack {
            HStack{
                Text("Login")
                    .font(.title).bold()
            }
            VStack(spacing: 20){
                TextField("Enter Email", text: $email)
                    .padding(7)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal)
                    
                TextField("Enter Password", text: $password)
                    .padding(7)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal)
//                risharyal5@gmail.com
                Button(action: {
                    authVm.loginUser(email: email, pasword: password)
                    
                }, label: {
                    RoundedRectangle(cornerRadius: 10).frame(height: 40).padding(.horizontal)
                        .overlay {
                            if authVm.isLoginLoading {
                                ProgressView()
                            } else {
                                Text("Login").foregroundStyle(.white).bold()

                            }
                        }
                    
                })
            }
            
//            if let token = UserDefaults.standard.string(forKey: ApplicationText.token) {
//                Text(token)
//            }
            
            VStack(alignment:.leading){
                Text("Don't have an account?")
                Text("Tap here to Register.").foregroundStyle(.blue)
            }.font(.caption).padding()
                
            
            Spacer()
        }
    }
}

#Preview {
    login()
}
