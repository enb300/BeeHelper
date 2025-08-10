import SwiftUI

struct CustomSplashView: View {
    @State private var isActive = false
    @State private var logoScale = 0.5
    @State private var logoOpacity = 0.0
    @State private var textOpacity = 0.0
    
    var body: some View {
        if isActive {
            ContentView()
                .environmentObject(PuzzleService())
        } else {
            ZStack {
                // Background - you can customize this
                Color.black
                    .ignoresSafeArea()
                
                // Or use a custom background image
                // Image("splash_background")
                //     .resizable()
                //     .aspectRatio(contentMode: .fill)
                //     .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Custom app icon/logo
                    // Replace "app_icon" with your actual asset name
                    Image("app_icon") // Add your app icon to Assets.xcassets
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .onAppear {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                                logoScale = 1.0
                                logoOpacity = 1.0
                            }
                        }
                    
                    // App name with custom styling
                    Text("Bee Helper")
                        .font(.custom("Avenir-Black", size: 32)) // Use custom font if available
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .opacity(textOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.8).delay(0.3)) {
                                textOpacity = 1.0
                            }
                        }
                    
                    // Tagline (optional)
                    Text("Your daily word puzzle companion")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .opacity(textOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.8).delay(0.5)) {
                                textOpacity = 1.0
                            }
                        }
                    
                    Spacer()
                    
                    // Loading indicator at bottom
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                                .scaleEffect(textOpacity)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                    value: textOpacity
                                )
                        }
                    }
                    .padding(.bottom, 50)
                }
                .padding()
            }
            .onAppear {
                // Transition to main app after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    CustomSplashView()
        .environmentObject(PuzzleService())
}
