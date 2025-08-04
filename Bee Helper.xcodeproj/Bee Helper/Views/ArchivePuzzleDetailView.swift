import SwiftUI

struct ArchivePuzzleDetailView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @Environment(\.dismiss) private var dismiss
    @State private var showingAllWords = false
    
    let puzzle: PuzzleData
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header with dynamic title and date
                    VStack(spacing: 8) {
                        Text(getHeaderTitle(for: puzzle.date))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(getFormattedDate(puzzle.date))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Letters display
                    LetterDisplayView(letters: puzzle.letters, centerLetter: puzzle.centerLetter, puzzleDate: puzzle.date)
                        .padding(.horizontal, 20)
                    
                    // Stats
                    StatsView(puzzle: puzzle)
                        .padding(.horizontal, 20)
                    
                    // Word count table
                    WordCountTableView()
                        .padding(.horizontal, 20)
                    
                    // Prefix table
                    PrefixTableView()
                        .padding(.horizontal, 20)
                    
                    // Action button
                    Button("Reveal All Words") {
                        showingAllWords = true
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.body)
                            Text("Back")
                                .font(.body)
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAllWords) {
                AllWordsView()
                    .environmentObject(puzzleService)
            }
        }
    }
    
    private func getHeaderTitle(for date: Date) -> String {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        
        if calendar.isDate(date, inSameDayAs: today) {
            return "Today's Puzzle"
        } else if calendar.isDate(date, inSameDayAs: yesterday) {
            return "Yesterday's Puzzle"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayName = dateFormatter.string(from: date)
            return "\(dayName)'s Puzzle"
        }
    }
    
    private func getFormattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

struct ArchivePuzzleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePuzzle = PuzzleData(
            date: Date(),
            centerLetter: "E",
            letters: ["A", "E", "I", "L", "N", "O", "T"],
            words: ["ALIEN", "ALINE", "ANILE", "ANIL", "ANTI", "ELAIN", "ELAN", "ENTIA", "ETNA", "INLET", "INTEL", "LATEN", "LEANT", "LENTI", "LIANE", "LIEN", "LINE", "LINEN", "LINT", "NAIL", "NEAT", "NITE", "TAIL", "TALE", "TEAL", "TEIL", "TELA", "TILE", "TINE"],
            totalWords: 29,
            totalPangrams: 0,
            totalCompoundWords: 0,
            source: "Sample"
        )
        
        ArchivePuzzleDetailView(puzzle: samplePuzzle)
            .environmentObject(PuzzleService())
    }
} 