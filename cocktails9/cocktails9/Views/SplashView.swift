import SwiftUI

struct SplashView: View {
    
    @Binding var navigateToLogin: Bool
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color(.splash)
                .edgesIgnoringSafeArea(.all)
            
            // First image (black and white)
            Image("splashbw")
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 270)
            
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                progress = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                navigateToLogin = true
            }
        }
        
    }
}
