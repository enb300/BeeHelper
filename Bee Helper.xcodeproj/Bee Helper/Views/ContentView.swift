import SwiftUI

struct ContentView: View {
    @StateObject private var puzzleService = PuzzleService()
    
    var body: some View {
        TabView {
            TodayView()
                .environmentObject(puzzleService)
                .tabItem {
                    Image(systemName: "sun.max.fill")
                    Text("Today")
                }
            
            ArchiveView()
                .environmentObject(puzzleService)
                .tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("Archive")
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