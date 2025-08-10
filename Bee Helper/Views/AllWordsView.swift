import SwiftUI

struct AllWordsView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if let puzzle = puzzleService.currentPuzzle {
                        // Debug info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Debug Info")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Total words: \(puzzle.totalWords)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Words array count: \(puzzle.words.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if !puzzle.words.isEmpty {
                                Text("Sample words: \(Array(puzzle.words.prefix(5)))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        
                        // All words section
                        WordSection(
                            title: "All Words",
                            subtitle: "\(puzzle.totalWords) total words",
                            words: puzzle.words.sorted(),
                            color: .blue
                        )
                        
                        // Pangrams section
                        if !puzzle.pangrams.isEmpty {
                            WordSection(
                                title: "Pangrams",
                                subtitle: "\(puzzle.totalPangrams) pangrams (use all 7 letters)",
                                words: puzzle.pangrams.sorted(),
                                color: .orange
                            )
                        }
                        
                        // Compound words section
                        if !puzzle.compoundWords.isEmpty {
                            WordSection(
                                title: "Compound Words",
                                subtitle: "\(puzzle.totalCompoundWords) compound words",
                                words: puzzle.compoundWords.sorted(),
                                color: .green
                            )
                        }
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "textformat.abc")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                            
                            Text("No puzzle loaded")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Load a puzzle to see all words")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                    }
                }
                .padding()
            }
            .navigationTitle("All Words")
            .navigationBarTitleDisplayMode(.inline)
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

struct WordSection: View {
    let title: String
    let subtitle: String
    let words: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Debug info for words
            if words.isEmpty {
                Text("No words to display")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("Displaying \(words.count) words")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(words, id: \.self) { word in
                        WordCard(word: word, color: color)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct WordCard: View {
    let word: String
    let color: Color
    
    var body: some View {
        Text(word)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
    }
}
