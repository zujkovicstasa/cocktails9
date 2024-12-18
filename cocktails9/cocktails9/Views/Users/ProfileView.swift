//
//  profileView.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 28.11.24..
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("Profile")
            
    }
}

struct ProfileTab: View {
    var body: some View {
        NavigationStack {
            ProfileView()
        }
    }
}

#Preview {
    ProfileView()
}
