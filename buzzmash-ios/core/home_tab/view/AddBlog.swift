//
//  AddBlog.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct AddBlog: View {
    @State var title:String = ""
    @State var desc:String = ""
    @State var category:String = ""
    @ObservedObject var blogVM:BlogViewModel
    @State var selectedId:String = ""
    @Namespace var namesapce
    @State var showAlert:Bool = false
    @State var alertText:String = ""
    @State var alertColor:Color = .blue

    var body: some View {
        VStack {
            HStack{
                Text("Add New Blog")
            }
            TextField("Enter Title", text: $title)
               
                .textFieldStyle(.roundedBorder).padding(.horizontal)
            
            TextField("Description", text: $desc, axis: .vertical)
               

                        .textFieldStyle(.roundedBorder).padding(.horizontal)
            TextField("Enter Category", text: $category)
               
                .textFieldStyle(.roundedBorder).padding(.horizontal)
            
            VStack(alignment: .leading){
                Text("Some Famous Category").font(.footnote)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(blogVM.requiredBlogCategory, id: \.id){cat in
                            
                            
                            
                            VStack(spacing: 5) {
                                Text(cat.name).bold()
                                if (selectedId == cat.name){
                                    Rectangle().frame(height: 3)
                                        .foregroundStyle(.green).matchedGeometryEffect(id: "category", in: namesapce)
                                }
                                else {
                                    Rectangle().frame(height: 3) .foregroundStyle(.clear)
                                }
                                
                            }
                            .onTapGesture(perform: {
                                withAnimation {
                                    selectedId = cat.name
                                    category = cat.name

                                }
                            })
                            
                            
                           
                           
                        }
                    }
                }
            }.padding().background(.gray.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
            
            
            
            Button {
                
                if (title.isEmpty || desc.isEmpty || category.isEmpty){
                    
                    
                    showAlert = true
                    alertText = "These Fields are required"
                    alertColor = .red
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showAlert = false
                            
                            
                           
                        }
                    }
                    
                } else {
                    blogVM.create(title: title, category: category, description: desc) { success in
                        if success {
                            
                            title = ""
                            category=""
                            desc=""
                            
                            withAnimation {
                                showAlert = true
                                
                                alertText = "Success"
                                alertColor = .green
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    showAlert = false
                                    
                                    
                                   
                                }
                            }
                        } else {
                            withAnimation {
                                showAlert = true
                                alertText = "Something Went wrong"
                                alertColor = .red
                                
                               
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    showAlert = false
                                    
                                   
                                }
                            }
                        }
                    }
                }
                
                
 
            } label: {
                RoundedRectangle(cornerRadius: 10).frame(height: 50).overlay {
                    if blogVM.isLoading {
                        ProgressView()
                    } else {
                        Text("Create").foregroundStyle(.white)
                    }
                    
                   
                }.padding(.horizontal).padding(.vertical,15)
            }

            Spacer()
        }.overlay(alignment: .top, content: {
            if showAlert {
                Text(alertText).foregroundStyle(.white).padding().background(alertColor).clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
        })
    }
}


