//
//  splahsScreen.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import Foundation
import SwiftUI





struct SplashScreen: View {
    var body: some View {
        VStack {
           Text("Buzzmash").font(.caption)
        }.foregroundStyle(.white).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(colors: [.blue.opacity(0.8), .green.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)).ignoresSafeArea()
    }
}
