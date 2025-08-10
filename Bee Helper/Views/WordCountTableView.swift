import SwiftUI

struct WordCountTableView: View {
    @EnvironmentObject var puzzleService: PuzzleService

    var body: some View {
        VStack(spacing: 16) {
            Text("Word Count by First Letter")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let puzzle = puzzleService.currentPuzzle {
                let wordCounts = puzzle.wordCountByFirstLetter
                let sortedLetters = wordCounts.keys.sorted()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    ForEach(sortedLetters, id: \.self) { letter in
                        WordCountCard(
                            letter: letter,
                            count: wordCounts[letter] ?? 0,
                            isCenterLetter: letter == puzzle.centerLetter
                        )
                    }
                }
            } else {
                ProgressView()
                    .frame(height: 100)
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
                Circle()
                    .fill(isCenterLetter ? Color.orange : Color.blue)
                    .frame(width: 40, height: 40)
                
                Text(letter)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text("\(count)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(width: 70, height: 80)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
