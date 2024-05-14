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

    var body: some View {
        
        VStack {
            HStack{
                Text("Register")
                    .font(.title).bold()
            }
            VStack(spacing: 20){
                
                TextField("Enter Email", text: $email)
                    .padding(7)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal)
                    
                TextField("Enter Name", text: $name)
                    .padding(7)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal)
                TextField("Enter Username", text: $username)
                    .padding(7)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal)
                DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) {
                             Text("Birth Date")
                        .padding(.horizontal)
                         }
                
//                Text("Date is \(birthDate.toFormattedString())")

                TextField("Enter Password", text: $password)
                    .padding(7)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal)
                
                Button(action: {
                    authVm.registerUser(email: email, password: password, name: name, username: username, DOB: birthDate.toFormattedString())
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
