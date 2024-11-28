//
//  mainTabView.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 28.11.24..
//

import SwiftUI

struct mainTabView: View {
    var body: some View {
        
        TabView{
            Text("Cocktails")
                .tabItem({
                    Image(systemName:"1.square.fill")
                    Text("Cocktails")
                    
                })
            Text("Favorites")
                .tabItem({
                    Image(systemName:"2.square.fill")
                    Text("Favorites")
                    
                })
            Text("Profile")
                .tabItem({
                    Image(systemName:"3.square.fill")
                    Text("Profile")
                    
                })
        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(Color.primary)
    }
}

#Preview {
    mainTabView()
}
