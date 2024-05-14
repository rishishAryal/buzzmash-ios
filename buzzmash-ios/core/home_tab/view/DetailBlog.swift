//
//  DetailBlog.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/13/24.
//

import SwiftUI

struct DetailBlog: View {
    @State var comment:String = ""
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
                    ProgressView()
                } else {
                    HStack {
                        Text("Comments(\(blogVM.requiredComment.count))").bold()
                        Spacer()
                    }.padding(.leading)
                    HStack{
                        TextField("Give your Thoughts", text: $comment, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .focused($keyboardFocus)
                            
                        if !comment.isEmpty {
                            Button(action: {
                                blogVM.addComment(blogId: blogId, comment: comment) { Bool in
                                    keyboardFocus = false
                                    comment = ""
                                }
                            }, label: {
                                RoundedRectangle(cornerRadius: 15).frame(width: 80).overlay {
                                    Text("Done").foregroundStyle(.white)
                                }
                            })
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
                                            Text(formatDateString(comment.createdAt)).foregroundStyle(.gray).font(.footnote)
                                        }
                                    }
                                    Spacer()
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
