import SwiftUI

struct TodayView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @State private var showingManualInput = false
    @State private var showingAllWords = false
    @State private var prefixLength = 2
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with letters
                    LetterDisplayView()
                    
                    // Stats section
                    StatsView()
                    
                    // Word count by first letter
                    WordCountTableView()
                    
                    // Prefix table
                    PrefixTableView(prefixLength: $prefixLength)
                    
                    // Reveal all words button
                    RevealWordsButton(showingAllWords: $showingAllWords)
                }
                .padding()
            }
            .navigationTitle("Today's Puzzle")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Manual Input") {
                        showingManualInput = true
                    }
                }
            }
            .sheet(isPresented: $showingManualInput) {
                ManualInputView()
                    .environmentObject(puzzleService)
            }
            .sheet(isPresented: $showingAllWords) {
                AllWordsView()
                    .environmentObject(puzzleService)
            }
            .refreshable {
                await puzzleService.fetchTodayPuzzle()
            }
        }
        .overlay(
            Group {
                if puzzleService.isLoading {
                    ProgressView("Loading puzzle...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                }
            }
        )
        .alert("Error", isPresented: .constant(puzzleService.errorMessage != nil)) {
            Button("OK") {
                puzzleService.errorMessage = nil
            }
        } message: {
            Text(puzzleService.errorMessage ?? "")
        }
    }
}

struct LetterDisplayView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Today's Letters")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let puzzle = puzzleService.currentPuzzle {
                HStack(spacing: 15) {
                    ForEach(puzzle.letters, id: \.self) { letter in
                        LetterCircle(
                            letter: letter,
                            isCenter: letter == puzzle.centerLetter
                        )
                    }
                }
            } else {
                Text("Loading letters...")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct LetterCircle: View {
    let letter: Character
    let isCenter: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isCenter ? Color.yellow : Color.blue)
                .frame(width: 50, height: 50)
            
            Text(String(letter))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

struct StatsView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Puzzle Stats")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let puzzle = puzzleService.currentPuzzle {
                HStack(spacing: 20) {
                    StatCard(title: "Total Words", value: "\(puzzle.totalWords)")
                    StatCard(title: "Pangrams", value: "\(puzzle.totalPangrams)")
                    StatCard(title: "Compound Words", value: "\(puzzle.totalCompoundWords)")
                }
            } else {
                Text("Loading stats...")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    TodayView()
        .environmentObject(PuzzleService())
} 