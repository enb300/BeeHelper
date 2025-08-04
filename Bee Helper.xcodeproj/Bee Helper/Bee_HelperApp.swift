import SwiftUI

@main
struct Bee_HelperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PuzzleService())
        }
    }
} 