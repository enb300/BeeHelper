import SwiftUI

struct ContentView: View {
    @StateObject private var puzzleService = PuzzleService()
    
    var body: some View {
        TabView {
            TodayView()
                .environmentObject(puzzleService)
                .tabItem {
                    Image(systemName: "sun.max")
                    Text("Today")
                }
            
            ArchiveView()
                .environmentObject(puzzleService)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Archive")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .onAppear {
            Task {
                await puzzleService.fetchTodayPuzzle()
            }
        }
    }
}

#Preview {
    ContentView()
} 