//
//  ViewCoordinator.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 29.11.24..
//

import SwiftUI

struct ViewCoordinator: View {
    @State private var isActive = false
        var body: some View {
            if isActive {
                ContentView()
            }else {
                SplashView(isActive: $isActive)
            }
        }
}

#Preview {
    ViewCoordinator()
}
