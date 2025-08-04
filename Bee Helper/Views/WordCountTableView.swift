import SwiftUI

struct WordCountTableView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Word Count by First Letter")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            if let puzzle = puzzleService.currentPuzzle {
                let wordCounts = puzzle.wordCountByFirstLetter
                
                if !wordCounts.isEmpty {
                    // Create a 4x2 grid layout for the 7 letters
                    VStack(spacing: 12) {
                        // First row (4 letters)
                        HStack(spacing: 12) {
                            ForEach(Array(wordCounts.keys.sorted().prefix(4)), id: \.self) { letter in
                                WordCountCard(
                                    letter: letter,
                                    count: wordCounts[letter] ?? 0,
                                    isCenterLetter: letter == puzzle.centerLetter
                                )
                            }
                        }
                        
                        // Second row (3 letters)
                        HStack(spacing: 12) {
                            ForEach(Array(wordCounts.keys.sorted().suffix(3)), id: \.self) { letter in
                                WordCountCard(
                                    letter: letter,
                                    count: wordCounts[letter] ?? 0,
                                    isCenterLetter: letter == puzzle.centerLetter
                                )
                            }
                            
                            // Empty space to maintain alignment
                            Spacer()
                        }
                    }
                } else {
                    Text("No word count data available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                }
            } else {
                Text("Loading word count data...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct WordCountCard: View {
    let letter: String
    let count: Int
    let isCenterLetter: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if isCenterLetter {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 40, height: 40)
                }
                
                Text(letter)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isCenterLetter ? .white : .primary)
            }
            
            Text("\(count)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
        .frame(width: 70, height: 80)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    WordCountTableView()
        .environmentObject(PuzzleService())
} 