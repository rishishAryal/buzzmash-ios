//
//  splahsScreen.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
import SwiftUI





struct SplashScreen: View {
    
    @StateObject var appInitVM:AppInitVM = AppInitVM.appInitVM
    @EnvironmentObject var authVm: AuthViewModel

    var body: some View {
        VStack {
           Text("Buzzmash").font(.largeTitle)
        }.foregroundStyle(.white).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(colors: [.blue.opacity(0.8), .green.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)).ignoresSafeArea()
            .onAppear(perform: {
                if authVm.isUserLogin {
                    appInitVM.getCategory() {success  in
                        
                        appInitVM.getUserProfile()
                    }
                }
               
            })
    }
}
