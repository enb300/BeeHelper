import SwiftUI

struct ComingSoonView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // Icon and title
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("Coming Soon")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Auto-fetch from NYT")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                // Description
                VStack(spacing: 12) {
                    Text("We're working on automatically fetching today's puzzle from the New York Times.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                    
                    Text("For now, use Create to enter your own letters!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                }
                
                // Create button
                Button(action: {
                    // This would navigate to manual input, but since it's the main tab now,
                    // we'll just show a message
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create Puzzle")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .disabled(true)
                .opacity(0.6)
                
                Spacer()
            }
            .navigationTitle("Coming Soon")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ComingSoonView()
        .environmentObject(PuzzleService())
} 