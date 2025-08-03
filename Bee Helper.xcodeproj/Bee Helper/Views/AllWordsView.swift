import SwiftUI

struct AllWordsView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if let puzzle = puzzleService.currentPuzzle {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            // Pangrams section
                            if !puzzle.pangrams.isEmpty {
                                WordsSection(
                                    title: "Pangrams (\(puzzle.pangrams.count))",
                                    words: puzzle.pangrams,
                                    color: .orange
                                )
                            }
                            
                            // Compound words section
                            if !puzzle.compoundWords.isEmpty {
                                WordsSection(
                                    title: "Compound Words (\(puzzle.compoundWords.count))",
                                    words: puzzle.compoundWords,
                                    color: .green
                                )
                            }
                            
                            // All words section
                            WordsSection(
                                title: "All Words (\(puzzle.words.count))",
                                words: puzzle.words.sorted(),
                                color: .blue
                            )
                        }
                        .padding()
                    }
                } else {
                    Text("No puzzle data available")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("All Words")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct WordsSection: View {
    let title: String
    let words: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
                .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach(words, id: \.self) { word in
                    Text(word)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.2))
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AllWordsView()
        .environmentObject(PuzzleService())
} 