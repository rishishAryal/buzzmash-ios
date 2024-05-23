//
//  ShimmerView.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/17/24.
//

import SwiftUI

import SwiftUI
struct ShimmerEffectBox: View {
    private var gradientColors = [ 
        Color(uiColor: UIColor.systemGray5),
        Color(uiColor: UIColor.systemGray6),
        Color(uiColor: UIColor.systemGray5)
    ]
    @State var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State var endPoint: UnitPoint = .init(x: 0, y: -0.2)
    var body: some View {
        LinearGradient (colors: gradientColors,
                        startPoint: startPoint,
                        endPoint: endPoint)
        .onAppear {
            withAnimation (.easeInOut (duration: 1)
                .repeatForever (autoreverses: false)) {
                    startPoint = .init(x: 1, y: 1)
                    endPoint = .init(x: 2.2, y: 2.2)
                }
        }
    }
}

struct CommentShimmer:View {
    var body: some View {
        VStack {
      
            ForEach(0..<4){i in
                HStack {
                    ShimmerEffectBox().frame(width: 35 ,height: 35)
                        .clipShape(Circle())
                   
                    VStack(alignment: .leading){
                        ShimmerEffectBox().frame(width: 100,height: 10)
                        HStack{
                            ShimmerEffectBox().frame(width: 150,height: 10)
                            Spacer()
                            ShimmerEffectBox().frame(width: 20,height: 10)
                            ShimmerEffectBox().frame(width: 20,height: 10)

                        }

                    }
                    Spacer()
                    
                        
                    
                }
                
            }
        }.padding().background(.gray.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 20)).padding()
   
    }
}

#Preview(body: {
    DashboardShimmer()
})



struct FeedShimmer:View {
    var body: some View {
        VStack{
            ScrollView{
                ForEach(0..<10) {i in
                    VStack {
                        HStack{
                            ShimmerEffectBox()
                                .frame(width: 15 ,height: 15)
                                .clipShape(Circle())
                            
                            ShimmerEffectBox()
                                .frame(width: 75 ,height: 12)
                            ShimmerEffectBox()
                                .frame(width: 10 ,height: 12)
                            ShimmerEffectBox()
                                .frame(width: 30 ,height: 12)
                            Spacer()
                            ShimmerEffectBox()
                                .frame(width: 90 ,height: 12)
                        }.padding(.horizontal)
                        
                        HStack{
                            VStack(alignment: .center){
                                Image(systemName: "arrowshape.up.fill").foregroundStyle(.gray).font(.footnote)
                                ShimmerEffectBox()
                                    .frame(width: 10 ,height: 12)
                            }
                            
                            ShimmerEffectBox()
                                .frame(width: 190 ,height: 15)
                            
                            Spacer()
                            
                            ShimmerEffectBox()
                                .frame(width: 50 ,height: 50)
                            
                            
                        }.padding(.horizontal)

                    }.padding(.vertical).overlay(alignment: .bottom) {
                        Rectangle().frame( height: 1).foregroundStyle(.gray.opacity(0.5))
                    }
                }
            }
        
        }
    }
}


struct CategoryShimmer :View {
    var body: some View {
        
            ScrollView(.horizontal, showsIndicators: false) {
                
                
                HStack{
                    ForEach(0..<10) {i in
                        ShimmerEffectBox()
                            .frame(width: 50 ,height: 15)
                    }
                }.padding()
            }.padding().background(.gray.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
        
    }
}

struct DashboardShimmer:View {
    var body: some View {
        ScrollView {
            ForEach(0..<10){i in
                HStack {
                    ShimmerEffectBox() .frame(width: 100, height: 100)
                   
                    
                    VStack(alignment: .leading){
                        ShimmerEffectBox() .frame(width: 120, height: 13)
                        ShimmerEffectBox() .frame(width: 90, height: 13)

                    }
                    Spacer()
                    
                    HStack {
                        ShimmerEffectBox() .frame(width: 70, height: 30).clipShape(RoundedRectangle(cornerRadius: 10))
                        ShimmerEffectBox() .frame(width: 40, height: 30).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }.padding(.horizontal)
               
                
            }
        }
    }
}
