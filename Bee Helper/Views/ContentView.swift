import SwiftUI

struct ContentView: View {
    @StateObject private var puzzleService = PuzzleService()
    
    var body: some View {
        TabView {
            ManualInputView()
                .environmentObject(puzzleService)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Create")
                }
            
            ComingSoonView()
                .environmentObject(puzzleService)
                .tabItem {
                    Image(systemName: "clock.badge.questionmark")
                    Text("Coming Soon")
                }
            
            SettingsView()
                .environmentObject(puzzleService)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PuzzleService())
}
