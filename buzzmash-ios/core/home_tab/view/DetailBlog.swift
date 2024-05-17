//
//  DetailBlog.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/13/24.
//

import SwiftUI

struct DetailBlog: View {
    @State var commentText:String = ""
    @State var blogId:String
    @State var profileImage:String
    @State var author:String
    @State var date:String
    @State var category:String
    @State var title:String
    @State var desc:String
    @State var thumbnail:String
    @ObservedObject var blogVM:BlogViewModel
    @FocusState var keyboardFocus
    @State var selectedCommentId:String = ""
    @State var selectedCommentIdForEdit:String = ""
    @State var isEditCommentSelected:Bool = false
    
    func getUserId()->String {
        if let id = UserDefaults.standard.string(forKey: "userId") {
            return id
        } else {
            return "no id"
        }
    }
    
    func formatDateString(_ dateString: String) -> String {
        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()

        // Set the input format to match the given date string
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        // Parse the given date string
        if let date = dateFormatter.date(from: dateString) {
            // Set the output format
            dateFormatter.dateFormat = "MMM d, yyyy"
            
            // Format the date
            let formattedDate = dateFormatter.string(from: date)
            
            // Return the formatted date
            return formattedDate
        } else {
            return "Invalid date format"
        }
    }
    
//    @State var commentCount:String
    var body: some View {
        ScrollView{
            VStack {
             
                
                

                    HStack{
                        if !profileImage.isEmpty {
                            AsyncImage(url: URL(string: profileImage)) { image in
                                      image
                                          .resizable()
                                          .aspectRatio(contentMode: .fill)
                                          .frame(width: 25 ,height: 25)
                                          .clipShape(Circle())
                                          
                                  } placeholder: {
                                      Color.gray
                                          .frame(width: 25, height: 25)
                                          .clipShape(Circle())
                                  }
                        }
                        Text(author)
                        Text("in").foregroundStyle(.gray)
                        Text(category)
                        Spacer()
                        Text(date).foregroundStyle(.gray)
                    }.font(.callout).padding(.horizontal)
                    
                    
                
                Text(title).padding(5).bold()
                if !thumbnail.isEmpty{
                    AsyncImage(url: URL(string: thumbnail)) { image in
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: UIScreen.main.bounds.width  ,height: 250)
                                  .clipShape(Rectangle())
                                  
                          } placeholder: {
                              Color.gray
                                  .frame(width: UIScreen.main.bounds.width  ,height: 250)
                                  .clipShape(Rectangle())
                          }
                }
                
              
                
                Text(desc).multilineTextAlignment(.leading).padding()
                
                
                if blogVM.getCommentisLoading {
                    HStack{
                        ShimmerEffectBox().frame(width: 100 ,height: 20)
                        Spacer()
                    }.padding(.leading)
                    HStack{
                        ShimmerEffectBox().frame(height: 20)
                        Spacer()
                    }.padding()
                    CommentShimmer()
                  
                    
                } else {
                    HStack {
                        Text("Comments(\(blogVM.requiredComment.count))").bold()
                        Spacer()
                    }.padding(.leading)
                    HStack{
                        TextField("Give your Thoughts", text: $commentText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .focused($keyboardFocus)
                            
                        
                        
                        if isEditCommentSelected {
                            Button(action: {
                                
                                
                                
                                blogVM.editComment(commentId: selectedCommentIdForEdit, comment: commentText) { success in
                                    if success {
                                        selectedCommentIdForEdit = ""
                                        commentText = ""
                                        isEditCommentSelected = false
                                        keyboardFocus = false

                                    }
                                  
                                }
                            }, label: {
                                RoundedRectangle(cornerRadius: 15).frame(width: 80).overlay {
                                    Text("Edit").foregroundStyle(.white)
                                }
                            })
                        }
                        else {
                            
                            if !commentText.isEmpty {
                                Button(action: {
                                    
                                    
                                    
                                    blogVM.addComment(blogId: blogId, comment: commentText) { Bool in
                                        keyboardFocus = false
                                        commentText = ""
                                    }
                                }, label: {
                                    RoundedRectangle(cornerRadius: 15).frame(width: 80).overlay {
                                        Text("Done").foregroundStyle(.white)
                                    }
                                })
                            }
                        }
                        
               
                       
                    }.padding()
                    
                    
                    if blogVM.requiredComment.count > 0 {
                        VStack(spacing: 20){
                            
                            ForEach(blogVM.requiredComment, id: \.id) { comment in
                                HStack {
                                    if !comment.profilePicture.isEmpty {
                                        AsyncImage(url: URL(string: comment.profilePicture)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 35 ,height: 35)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 35, height: 35)
                                                .clipShape(Circle())
                                        }
                                    }
                                    VStack(alignment: .leading){
                                        Text(comment.name).font(.footnote)
                                        HStack{
                                            Text(comment.comment).font(.footnote).fontWeight(.light)
                                            Spacer()
                                            if comment.userID == getUserId() {
                                                HStack{
                                                    Image(systemName: "pencil").onTapGesture {
                                                        isEditCommentSelected = true
                                                        commentText = comment.comment
                                                        selectedCommentIdForEdit = comment.id
                                                        keyboardFocus = true


                                                    }
                                                    Button{
//                                                        blogVM.deleteComment(commentId: comment.id)
                                                        selectedCommentId = comment.id
                                                    }
                                                        
                                                     label: {
                                                        Image(systemName: "bin.xmark.fill").foregroundStyle(.red)
                                                          
                                                    }

                                                 
                                                }.font(.caption)  
                                                  
                                                
                                            }
                                        }
                                    }
                                    Spacer()
                                }  .overlay(alignment: .bottom) {
                                    
                                    if selectedCommentId == comment.id {
                                        VStack {
                                            
                                                Text("Delete this comment?")
                                            HStack(spacing: 20) {
                                                    Text("NO") .onTapGesture {
                                                        selectedCommentId = ""
                                                    }
                                                Text("YES").foregroundStyle(.red).onTapGesture {
                                                    blogVM.deleteComment(commentId: comment.id)
                                                    selectedCommentId = ""
                                                }
                                                }
                                            
                                            
                                        }.frame(width: 150, height: 50).font(.footnote).padding(5).background(.gray).zIndex(10).offset(x:0,y:13)
                                    }
                             
                                   
                                
                            }
                            }

                            
                            
                        }.padding().background(.gray.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 20)).padding()
                    }
                   
                }
                
   
                
                

                
            }
        }.onAppear(perform: {
            blogVM.getComments(blogId: blogId) {isSuccess in
                
                
            }
        })
    }
}
