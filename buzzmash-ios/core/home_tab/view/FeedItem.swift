//
//  FeedItem.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/29/24.
//

import SwiftUI

struct FeedItem: View {
    var authorProfile:String
    var author:String
    var category:String
    var createdAt:String
    var blogId:String
    @ObservedObject var blogVM:BlogViewModel
    var hasLiked:Bool
    var likeCount:Int
    var title:String
    var thumbnail:String
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
    var body: some View {
        VStack {
            HStack {
             
                   
                    if !authorProfile.isEmpty {
                        AsyncImage(url: URL(string: authorProfile)) { image in
                                  image
                                      .resizable()
                                      .aspectRatio(contentMode: .fill)
                                      .frame(width: 15 ,height: 15)
                                      .clipShape(Circle())
                                      
                              } placeholder: {
                                  ShimmerEffectBox()
                                      .frame(width: 15, height: 15)
                                      .clipShape(Circle())
                              }
                              
                    }

                    Text(" By \(author)").font(.footnote)
                Text("in").font(.footnote).fontWeight(.light).foregroundStyle(.gray)
                Text("\(category)").font(.footnote)

                    
                
                
                Spacer()
                Text(formatDateString(createdAt)).foregroundStyle(.gray).font(.footnote)
                
            }.padding(.horizontal)
            
            
       
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    blogVM.likeunlikeBlog(blogId: blogId) { success in
                        if success {
                            if let index = blogVM.requiredBlogFeed.firstIndex(where: { $0.id == blogId }) {
                                blogVM.requiredBlogFeed[index].hasLiked.toggle()
                                blogVM.requiredBlogFeed[index].likeCount += (blogVM.requiredBlogFeed[index].hasLiked ? 1 : -1)
                            }
                            
                            if let index = blogVM.requiredFollowingFeed.firstIndex(where: { $0.id == blogId }) {
                                blogVM.requiredFollowingFeed[index].hasLiked.toggle()
                                blogVM.requiredFollowingFeed[index].likeCount += (blogVM.requiredFollowingFeed[index].hasLiked ? 1 : -1)
                            }

                        }
                    }
                } label: {
                    
                    VStack(alignment: .center){
                        Image(systemName: hasLiked ? "arrowshape.up.fill" : "arrowshape.up").foregroundStyle(hasLiked ? .red : .gray).font(.footnote)
                        Text("\(likeCount)").foregroundStyle(.gray).font(.footnote)
                    }
                }
                Text(title).bold().multilineTextAlignment(.leading)
                
               Spacer()
                
                if !thumbnail.isEmpty {
                    AsyncImage(url: URL(string: thumbnail)) { image in
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: 50, height: 50)
                                  .clipShape(Rectangle())
                                  
                          } placeholder: {
                              ShimmerEffectBox()
                                  .frame(width: 50, height: 50)
                          }
                          
                } else {
                    Color.clear
                        .frame(width: 50, height: 50)
                }
            }.padding(.horizontal)
       
          
            

            
        }.foregroundStyle(Color.text).padding(.vertical).overlay(alignment: .bottom) {
            Rectangle().frame( height: 1).foregroundStyle(.gray.opacity(0.5))
        }
    }
}


