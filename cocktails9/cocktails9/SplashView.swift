//
//  SplashScreenView.swift
//  cocktails9
//
//  Created by Stasa Zujkovic on 27.11.24..
//

import SwiftUI

struct SplashView: View {
    
    @Binding var isActive: Bool
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        
        ZStack {
            
            ZStack{
                Color(red: 0.701, green: 0.854, blue: 0.99)
                    .edgesIgnoringSafeArea(.all)
                
                // First image (black and white)
                Image("splashbw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270,height:270)
                
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
                
            }
            .onAppear {
                
                // Start the animation for the fade-in and mask
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    progress = 1.0
                }
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isActive = true
            }
        }
    }
}

#Preview {
    SplashView(isActive: .constant(true))
}
