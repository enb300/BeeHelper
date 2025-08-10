import SwiftUI
import WebKit

struct EnhancedSplashView: View {
    @StateObject private var puzzleService = PuzzleService()
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var loadingText = "Initializing..."
    @State private var loadingProgress = 0.0
    @State private var loadingStep = 0
    
    var body: some View {
        if isActive {
            ContentView()
                .environmentObject(puzzleService)
        } else {
            ZStack {
                // Background gradient with app colors
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#FFCC00"), Color(hex: "#E6BA26")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    // Custom bee SVG above app title
                    BeeIcon()
                        .frame(width: 80, height: 80)  // Increased from 60x60 to 80x80
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            // Start loading animation immediately
                            if loadingStep == 0 {
                                startLoadingAnimation()
                            }
                        }
                    
                    // App name - larger and black
                    Text("Bee Helper")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)
                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    // Loading text
                    Text(loadingText)
                        .font(.headline)
                        .foregroundColor(.black)
                        .opacity(opacity)
                    
                    // Progress bar with white gradient
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 300, height: 20)
                        
                        // Progress bar with white gradient
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.9)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 300 * loadingProgress, height: 20)
                            .animation(.easeInOut(duration: 0.3), value: loadingProgress)
                    }
                    .opacity(opacity)
                    
                    // Loading indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(1.2)
                        .opacity(opacity)
                }
            }
            .onAppear {
                // Start initial animation immediately
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
            }
        }
    }
    
    private func startLoadingAnimation() {
        loadingStep = 1
        
        // Simulate loading steps
        let loadingSteps = [
            ("Loading dictionary...", 0.3),
            ("Preparing puzzles...", 0.6),
            ("Almost ready...", 0.9),
            ("Ready!", 1.0)
        ]
        
        var currentStep = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer in
            if currentStep < loadingSteps.count {
                let (text, progress) = loadingSteps[currentStep]
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.loadingText = text
                    self.loadingProgress = progress
                }
                currentStep += 1
            } else {
                timer.invalidate()
                // Wait a bit more then transition
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

// SVG-converted bee icon from Layer_2
struct BeeIcon: View {
    
    static let intrinsicSize = CGSize(width: 120, height: 108)
    
    // Modifiers and Statics
    static let paint0_linear_0_4 = LinearGradient(
        gradient: .init(colors: [
            .init(0x2E1C09), .init(0x4D2F0F)
        ]),
        startPoint: .init(x: 25.4233, y: 15.5277),
        endPoint: .init(x: 94.7596, y: 84.8488)
    )
    
    // Nested Groups and Shapes
    struct PathView1: View { // SVGPath
        
        struct PathShape1: Shape {
            
            func path(in rect: CGRect) -> Path {
                Path { path in
                    path.move(to: .init(x: 119.904, y: 47.7024))
                    path.addCurve(to: .init(x: 106.414, y: 29.5292),
                                  control1: .init(x: 119.113, y: 40.0064),
                                  control2: .init(x: 113.506, y: 32.622))
                    path.addCurve(to: .init(x: 83.147, y: 29.9368),
                                  control1: .init(x: 98.8179, y: 26.1247),
                                  control2: .init(x: 90.8387, y: 27.7311))
                    path.addCurve(to: .init(x: 68.1709, y: 14.0412),
                                  control1: .init(x: 81.254, y: 22.6483),
                                  control2: .init(x: 75.2636, y: 16.5586))
                    path.addCurve(to: .init(x: 74.0655, y: 7.6399),
                                  control1: .init(x: 69.2732, y: 11.1402),
                                  control2: .init(x: 71.1661, y: 8.7427))
                    path.addCurve(to: .init(x: 79.361, y: 5.4341),
                                  control1: .init(x: 75.9585, y: 6.9446),
                                  control2: .init(x: 78.1629, y: 7.3522))
                    path.addCurve(to: .init(x: 79.0495, y: 1.1426),
                                  control1: .init(x: 80.2716, y: 4.0436),
                                  control2: .init(x: 80.1518, y: 2.3413))
                    path.addCurve(to: .init(x: 73.4665, y: 0.4473),
                                  control1: .init(x: 77.5399, y: -0.4638),
                                  control2: .init(x: 75.3594, y: -0.0562))
                    path.addCurve(to: .init(x: 61.3898, y: 12.7466),
                                  control1: .init(x: 67.5719, y: 1.9577),
                                  control2: .init(x: 62.9713, y: 6.8487))
                    path.addLine(to: .init(x: 58.5863, y: 12.7466))
                    path.addCurve(to: .init(x: 46.5096, y: 0.4473),
                                  control1: .init(x: 56.9808, y: 6.8487),
                                  control2: .init(x: 52.4042, y: 1.9577))
                    path.addCurve(to: .init(x: 40.9265, y: 1.1426),
                                  control1: .init(x: 44.6166, y: -0.0562),
                                  control2: .init(x: 42.4121, y: -0.4638))
                    path.addCurve(to: .init(x: 40.615, y: 5.4341),
                                  control1: .init(x: 39.8243, y: 2.3413),
                                  control2: .init(x: 39.7284, y: 4.0436))
                    path.addCurve(to: .init(x: 45.9105, y: 7.6399),
                                  control1: .init(x: 41.8131, y: 7.3282),
                                  control2: .init(x: 44.0176, y: 6.9446))
                    path.addCurve(to: .init(x: 51.8051, y: 14.0412),
                                  control1: .init(x: 48.8099, y: 8.7427),
                                  control2: .init(x: 50.7029, y: 11.1402))
                    path.addCurve(to: .init(x: 36.8291, y: 29.9368),
                                  control1: .init(x: 44.7125, y: 16.5347),
                                  control2: .init(x: 38.722, y: 22.6244))
                    path.addCurve(to: .init(x: 13.5623, y: 29.5292),
                                  control1: .init(x: 29.1374, y: 27.7311),
                                  control2: .init(x: 21.1581, y: 26.1487))
                    path.addCurve(to: .init(x: 0.0719, y: 47.7024),
                                  control1: .init(x: 6.4696, y: 32.598),
                                  control2: .init(x: 0.8626, y: 40.0064))
                    path.addCurve(to: .init(x: 0.0719, y: 52.5933),
                                  control1: .init(x: -0.024, y: 48.9971),
                                  control2: .init(x: -0.024, y: 51.3946))
                    path.addCurve(to: .init(x: 16.1502, y: 71.6776),
                                  control1: .init(x: 0.9824, y: 61.2963),
                                  control2: .init(x: 7.8594, y: 69.2801))
                    path.addCurve(to: .init(x: 35.4153, y: 70.5747),
                                  control1: .init(x: 22.7396, y: 73.5716),
                                  control2: .init(x: 28.9217, y: 72.0852))
                    path.addLine(to: .init(x: 35.4153, y: 75.8493))
                    path.addCurve(to: .init(x: 36.2061, y: 82.7062),
                                  control1: .init(x: 35.4153, y: 78.1509),
                                  control2: .init(x: 35.655, y: 80.4765))
                    path.addCurve(to: .init(x: 36.2061, y: 82.7541),
                                  control1: .init(x: 36.2061, y: 82.7062),
                                  control2: .init(x: 36.2061, y: 82.7302))
                    path.addCurve(to: .init(x: 56.3099, y: 100.616),
                                  control1: .init(x: 38.6981, y: 92.0325),
                                  control2: .init(x: 46.8451, y: 99.2011))
                    path.addLine(to: .init(x: 56.3099, y: 104.308))
                    path.addCurve(to: .init(x: 58.778, y: 107.784),
                                  control1: .init(x: 56.3099, y: 105.914),
                                  control2: .init(x: 57.3403, y: 107.281))
                    path.addCurve(to: .init(x: 58.8738, y: 107.808),
                                  control1: .init(x: 58.8019, y: 107.784),
                                  control2: .init(x: 58.8498, y: 107.784))
                    path.addCurve(to: .init(x: 59.9281, y: 108),
                                  control1: .init(x: 59.2093, y: 107.928),
                                  control2: .init(x: 59.5447, y: 108))
                    path.addCurve(to: .init(x: 60, y: 108),
                                  control1: .init(x: 59.9281, y: 108),
                                  control2: .init(x: 59.976, y: 108))
                    path.addCurve(to: .init(x: 60.0719, y: 108),
                                  control1: .init(x: 60.024, y: 108),
                                  control2: .init(x: 60.0479, y: 108))
                    path.addCurve(to: .init(x: 61.1262, y: 107.808),
                                  control1: .init(x: 60.4313, y: 108),
                                  control2: .init(x: 60.7907, y: 107.928))
                    path.addCurve(to: .init(x: 61.222, y: 107.784),
                                  control1: .init(x: 61.1502, y: 107.808),
                                  control2: .init(x: 61.1981, y: 107.808))
                    path.addCurve(to: .init(x: 63.6901, y: 104.308),
                                  control1: .init(x: 62.6597, y: 107.257),
                                  control2: .init(x: 63.6901, y: 105.914))
                    path.addLine(to: .init(x: 63.6901, y: 100.616))
                    path.addCurve(to: .init(x: 83.7939, y: 82.7541),
                                  control1: .init(x: 73.155, y: 99.2011),
                                  control2: .init(x: 81.3019, y: 92.0086))
                    path.addCurve(to: .init(x: 83.7939, y: 82.7062),
                                  control1: .init(x: 83.7939, y: 82.7541),
                                  control2: .init(x: 83.7939, y: 82.7302))
                    path.addCurve(to: .init(x: 84.5847, y: 75.8493),
                                  control1: .init(x: 84.3451, y: 80.4525),
                                  control2: .init(x: 84.5847, y: 78.1509))
                    path.addLine(to: .init(x: 84.5847, y: 70.5747))
                    path.addCurve(to: .init(x: 103.85, y: 71.6776),
                                  control1: .init(x: 91.0783, y: 72.0852),
                                  control2: .init(x: 97.2604, y: 73.5716))
                    path.addCurve(to: .init(x: 119.928, y: 52.5933),
                                  control1: .init(x: 112.141, y: 69.2801),
                                  control2: .init(x: 119.018, y: 61.2963))
                    path.addCurve(to: .init(x: 119.928, y: 47.7024),
                                  control1: .init(x: 120.024, y: 51.3946),
                                  control2: .init(x: 120.024, y: 48.9971))
                    path.addLine(to: .init(x: 119.904, y: 47.7024))
                    path.closeSubpath()
                    
                    path.move(to: .init(x: 60, y: 19.6275))
                    path.addCurve(to: .init(x: 76.7732, y: 32.1185),
                                  control1: .init(x: 67.1885, y: 19.6275),
                                  control2: .init(x: 74.377, y: 24.0149))
                    path.addCurve(to: .init(x: 66.3978, y: 37.7047),
                                  control1: .init(x: 73.1789, y: 33.9167),
                                  control2: .init(x: 69.5847, y: 35.4271))
                    path.addCurve(to: .init(x: 60, y: 44.202),
                                  control1: .init(x: 64.0016, y: 39.407),
                                  control2: .init(x: 61.4137, y: 41.7086))
                    path.addCurve(to: .init(x: 53.6022, y: 37.7047),
                                  control1: .init(x: 58.6102, y: 41.7086),
                                  control2: .init(x: 55.9984, y: 39.407))
                    path.addCurve(to: .init(x: 43.2268, y: 32.1185),
                                  control1: .init(x: 50.4153, y: 35.4031),
                                  control2: .init(x: 46.8211, y: 33.9167))
                    path.addCurve(to: .init(x: 60, y: 19.6275),
                                  control1: .init(x: 45.623, y: 24.0149),
                                  control2: .init(x: 52.8115, y: 19.6275))
                    path.closeSubpath()
                    
                    path.move(to: .init(x: 64.1933, y: 60.673))
                    path.addCurve(to: .init(x: 69.0815, y: 64.2693),
                                  control1: .init(x: 65.7029, y: 61.9676),
                                  control2: .init(x: 67.5, y: 62.9746))
                    path.addLine(to: .init(x: 50.9185, y: 64.2693))
                    path.addCurve(to: .init(x: 55.8067, y: 60.673),
                                  control1: .init(x: 52.524, y: 62.9746),
                                  control2: .init(x: 54.3211, y: 61.9676))
                    path.addCurve(to: .init(x: 60, y: 56.0697),
                                  control1: .init(x: 57.3163, y: 59.3783),
                                  control2: .init(x: 58.8019, y: 57.772))
                    path.addCurve(to: .init(x: 64.1933, y: 60.673),
                                  control1: .init(x: 61.1981, y: 57.772),
                                  control2: .init(x: 62.7077, y: 59.3783))
                    path.closeSubpath()
                    
                    path.move(to: .init(x: 22.7396, y: 65.8756))
                    path.addLine(to: .init(x: 22.7396, y: 65.7797))
                    path.addCurve(to: .init(x: 7.1645, y: 49.093),
                                  control1: .init(x: 13.8498, y: 65.7797),
                                  control2: .init(x: 6.5655, y: 57.8919))
                    path.addCurve(to: .init(x: 20.4393, y: 34.8037),
                                  control1: .init(x: 7.6677, y: 42.0922),
                                  control2: .init(x: 13.4665, y: 35.5949))
                    path.addCurve(to: .init(x: 50.7987, y: 44.5856),
                                  control1: .init(x: 28.8259, y: 33.7968),
                                  control2: .init(x: 44.2093, y: 39.3111))
                    path.addCurve(to: .init(x: 54.1054, y: 52.2817),
                                  control1: .init(x: 53.1949, y: 46.4797),
                                  control2: .init(x: 55.6869, y: 49.093))
                    path.addCurve(to: .init(x: 22.7396, y: 65.8756),
                                  control1: .init(x: 50.5112, y: 59.3783),
                                  control2: .init(x: 30.3355, y: 65.9715))
                    path.closeSubpath()
                    
                    path.move(to: .init(x: 60, y: 93.9505))
                    path.addCurve(to: .init(x: 45.1198, y: 85.4633),
                                  control1: .init(x: 53.9137, y: 93.9505),
                                  control2: .init(x: 48.2109, y: 90.8577))
                    path.addLine(to: .init(x: 74.8802, y: 85.4633))
                    path.addCurve(to: .init(x: 60, y: 93.9505),
                                  control1: .init(x: 71.7891, y: 90.8577),
                                  control2: .init(x: 66.0863, y: 93.9505))
                    path.closeSubpath()
                    
                    path.addLines([
                        .init(x: 77.5639, y: 78.079),
                        .init(x: 77.1566, y: 78.4865),
                        .init(x: 42.7955, y: 78.4865),
                        .init(x: 42.3882, y: 78.079),
                        .init(x: 42.3882, y: 71.3899),
                        .init(x: 77.5399, y: 71.3899),
                        .init(x: 77.5399, y: 78.079),
                        .init(x: 77.5639, y: 78.079)
                    ])
                    path.closeSubpath()
                    
                    path.move(to: .init(x: 97.2364, y: 65.7797))
                    path.addLine(to: .init(x: 97.2364, y: 65.8756))
                    path.addCurve(to: .init(x: 65.8706, y: 52.2817),
                                  control1: .init(x: 89.6406, y: 65.9715),
                                  control2: .init(x: 69.4649, y: 59.3783))
                    path.addCurve(to: .init(x: 69.1773, y: 44.5856),
                                  control1: .init(x: 64.2652, y: 49.093),
                                  control2: .init(x: 66.7812, y: 46.4797))
                    path.addCurve(to: .init(x: 99.5368, y: 34.8037),
                                  control1: .init(x: 75.7668, y: 39.2871),
                                  control2: .init(x: 91.1502, y: 33.7968))
                    path.addCurve(to: .init(x: 112.812, y: 49.093),
                                  control1: .init(x: 106.534, y: 35.5949),
                                  control2: .init(x: 112.308, y: 42.0922))
                    path.addCurve(to: .init(x: 97.2364, y: 65.7797),
                                  control1: .init(x: 113.411, y: 57.8919),
                                  control2: .init(x: 106.126, y: 65.7797))
                    path.closeSubpath()
                }
            }
        }
        
        var body: some View {
            PathShape1()
                .fill(BeeIcon.paint0_linear_0_4)
        }
    }
    
    var isResizable = false
    func resizable() -> Self { Self(isResizable: true) }
    
    var body: some View {
        if isResizable {
            GeometryReader { proxy in
                PathView1()
                    .frame(width: 120, height: 108,
                           alignment: .topLeading)
                    .scaleEffect(x: proxy.size.width / 120,
                                 y: proxy.size.height / 108)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        else {
            PathView1()
                .frame(width: 120, height: 108)
        }
    }
}

fileprivate extension Color {
    init(_ rgb: UInt32, opacity: Double = 1.0) {
        self.init(red: Double((rgb >> 16) & 0xFF) / 255.0,
                  green: Double((rgb >> 8) & 0xFF) / 255.0,
                  blue: Double(rgb & 0xFF) / 255.0,
                  opacity: opacity)
    }
}

// Extension to support hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    EnhancedSplashView()
}

