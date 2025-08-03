import SwiftUI

struct WordCountTableView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Word Count by First Letter")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let puzzle = puzzleService.currentPuzzle {
                VStack(spacing: 10) {
                    // Header row
                    HStack {
                        ForEach(puzzle.letters, id: \.self) { letter in
                            Text(String(letter))
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Count row
                    HStack {
                        ForEach(puzzle.letters, id: \.self) { letter in
                            Text("\(puzzle.wordCountByFirstLetter[letter] ?? 0)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            } else {
                Text("Loading word counts...")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    WordCountTableView()
        .environmentObject(PuzzleService())
} 