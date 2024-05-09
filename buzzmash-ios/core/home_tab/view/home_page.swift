//
//  home_page.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct FeedView:View {
    @ObservedObject var blogVM:BlogViewModel
    @State var selectedId:String = "all"
    @Namespace var namesapce
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text("Buzzmash")
                Spacer()
            }
            if(blogVM.getBlogCategoryIsLoading) {
                ProgressView()
            } else {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    
                    HStack {
                        VStack(spacing: 5) {
                            Text("All").bold()
                            if (selectedId == "all"){
                                Rectangle().frame(height: 3)
                                    .foregroundStyle(.green).matchedGeometryEffect(id: "category", in: namesapce)
                            }
                            else {
                                Rectangle().frame(height: 3) .foregroundStyle(.clear)
                            }
                            
                        }.onTapGesture(perform: {
                            withAnimation {
                                selectedId = "all"
                            }
                           
                        })
                        ForEach(blogVM.requiredBlogCategory, id: \.id){cat in
                            
                            
                            
                            VStack(spacing: 5) {
                                Text(cat.name).bold()
                                if (selectedId == cat.id){
                                    Rectangle().frame(height: 3)
                                        .foregroundStyle(.green).matchedGeometryEffect(id: "category", in: namesapce)
                                }
                                else {
                                    Rectangle().frame(height: 3) .foregroundStyle(.clear)
                                }
                                
                            }
                            .onTapGesture(perform: {
                                withAnimation {
                                    selectedId = cat.id

                                }
                            })
                            
                            
                           
                           
                        }
                    }.padding()
                   
                }.background(.gray)
              
            }
           
                if (blogVM.getBlogFeedIsLoading){
                    ProgressView()
                } else {
                   
                    ScrollView {
                        ForEach(blogVM.requiredBlogFeed, id: \.id) {blog in
                            
                            VStack {
                                HStack {
                                    Text(" By \(blog.author)").foregroundStyle(.gray).font(.footnote).fontWeight(.light)
                                    
                                    Spacer()
                                    
                                    Text("\(blog.category)").foregroundStyle(.gray).font(.footnote).fontWeight(.light)
                                }.padding(.horizontal)
                                
                                
                                if !blog.thumbnail.isEmpty {
                                    AsyncImage(url: URL(string: blog.thumbnail)) { image in
                                              image
                                                  .resizable()
                                                  .aspectRatio(contentMode: .fill)
                                                  .frame(width: UIScreen.main.bounds.width, height: 250)
                                                  .clipShape(Rectangle())
                                                  
                                          } placeholder: {
                                              Color.gray
                                                  .frame(width: UIScreen.main.bounds.width, height: 250)
                                          }
                                          
                                }
                                HStack {
                                    Text(blog.title).font(.title)
                                    
                                   Spacer()
                                }.padding(.horizontal)
                                HStack{
                                    Text(blog.description.count > 350 ? String(blog.description.prefix(50) + "...") : blog.description).foregroundStyle(.gray).font(.footnote).fontWeight(.light)
                                    Spacer()
                                }.padding(.horizontal)
                                
                                
                                VStack{
                                    Rectangle().frame(width: UIScreen.main.bounds.width, height: 0.1)
                                    HStack(spacing: 20) {
                                        HStack {
                                            Image(systemName: "heart")
                                            Text("\(blog.likeCount)")
                                           
                                        }
                                        HStack {
                                            Image(systemName: "message.fill")
                                            Text("\(blog.commentCount)")

                                        }
                                        Spacer()
                                    }.padding(.horizontal)
                                }
                            }.padding(.vertical)
                                .background {
                                    Rectangle().stroke(lineWidth: 0.2)
                                }
                            
                            
                        }
                    }
                }
            
            
    Spacer()
            
            
        }

    }
}
