//
//  Settings.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        VStack {
            
            List {
                HStack(spacing: 20){
                    Image(systemName: "pencil")
                    Text("Edit Profile")
                    Spacer()
            
                }
                
                
                HStack(spacing: 20) {
                    Image(systemName: "door.sliding.right.hand.open")
                    Text("Logout")
                    Spacer()
                }
            }.listStyle(.automatic)
           
           
            Spacer()
        }
        
        
    }
}

#Preview {
    Settings()
}
