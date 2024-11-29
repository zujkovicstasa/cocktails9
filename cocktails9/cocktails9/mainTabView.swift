//
//  mainTabView.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 28.11.24..
//

import SwiftUI

struct mainTabView: View {
    
    enum Tab {
           case cocktails
           case favorites
           case profile
       }
    
    @State var selectedTab: Tab = .cocktails
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            
            Group{
                
                switch selectedTab {
                    
                case .cocktails:
                    cocktailsView()
                case .favorites:
                    favoritesView()
                case .profile:
                    profileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack{
                
                Button{
                    selectedTab = .cocktails
                } label: {
                    VStack(spacing:0){
                        Image(systemName: "wineglass")
                            .frame(width:44, height:29)
                        Text("Cocktails")
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
                .foregroundStyle(selectedTab == .cocktails ? .primary : .secondary)
                
                Button{
                    selectedTab = .favorites
                } label: {
                    VStack(spacing:0){
                        Image(systemName: "heart")
                            .frame(width:44, height:29)
                        Text("Favorites")
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
                .foregroundStyle(selectedTab == .favorites ? .primary : .secondary)
                Button{
                    selectedTab = .profile
                } label: {
                    VStack(spacing:0){
                        Image(systemName: "person")
                            .frame(width:44, height:29)
                            
                        Text("Profile")
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
                .foregroundStyle(selectedTab == .profile ? .primary : .secondary)
                
            }
            
        }
        .padding(.horizontal, 8)
        .padding(.top, 14)
        .frame( height: 88, alignment: .top)
        .edgesIgnoringSafeArea(.top)
        .accentColor(Color.primary)
        .background(.ultraThinMaterial, in:
            RoundedRectangle(cornerRadius: 34))
        .background(
            HStack {
                Spacer()
                
                Circle().fill(.pink).frame(width:80)
                Spacer()
            }
            .padding(.horizontal, 8 )
            
        )
        .frame(maxHeight: . infinity, alignment: .bottom)
        .ignoresSafeArea(edges: .bottom)
        
        
    }
}

#Preview {
    mainTabView()
}
