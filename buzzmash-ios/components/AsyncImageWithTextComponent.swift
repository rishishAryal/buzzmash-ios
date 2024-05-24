//
//  AsyncImageWithTextComponent.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/24/24.
//

//
//  ImageComponentwithText.swift
//  memorylane
//
//  Created by Rishabh Aryal on 12/04/2024.
//

import SwiftUI

struct ImageComponentwithText: View {
    let name:String
    let image:String
    let height:CGFloat
    let width:CGFloat
    let fontsize:CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { phase in
            switch phase {
            case .empty:
                
                
                
                Circle().frame(width: width, height: height).foregroundStyle(.backGround)
                   
                .overlay {
                    if let firstCharacter = name.first {
                        Text("\(String(firstCharacter).capitalized)")
                            .font(.system(size: fontsize)).fontWeight(.bold)
                            .foregroundStyle(.text)
                    } else {
                        Text("") // or any default value you want to use when the character is nil
                    }
                }
                
            case .success(let image):
               
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipShape(Circle())
                

              
                  
                    
            case .failure:
               
                
                Circle() .frame(width: width, height: height).foregroundStyle(.text)
                   .foregroundStyle(.white)
                    .overlay {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                          
                            
                    }
                

               
          
            @unknown default:
                ProgressView()
            }
        }
    }
}

