//
//  SplashScreenView.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 27.11.24..
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var progress: CGFloat = 0.0
    @State private var zoomIn = false
    
    var body: some View {
        
        ZStack {
            
            // Background color
            Color(red: 0.701, green: 0.854, blue: 0.99)
                .edgesIgnoringSafeArea(.all)
            
            // First image (black and white)
            Image("splashbw")
                .resizable()
                .scaledToFit()
                .frame(width: 270,height:270)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            // Second image (color), masked by a rectangle that grows from bottom to top
            Image("splashclr")
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 270)
                .mask(
                    Rectangle()
                        .frame(width: 270, height: 270 * progress)
                        .animation(.easeInOut(duration: 1), value: progress)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .onAppear {
            
            // Start the animation for the fade-in and mask
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                progress = 1.0
            }
            
            
        }
    }
}

#Preview {
    SplashScreenView()
}
