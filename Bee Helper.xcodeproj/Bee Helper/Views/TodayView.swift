import SwiftUI

struct TodayView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @State private var showingManualInput = false
    @State private var showingAllWords = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Network and cache status indicators
                    VStack(spacing: 8) {
                        NetworkStatusView()
                        
                        if let cacheStatus = puzzleService.cacheStatus {
                            HStack {
                                Image(systemName: "externaldrive.fill")
                                    .foregroundColor(.green)
                                Text("\(cacheStatus.cachedPuzzles) puzzles cached")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(cacheStatus.dictionarySize) words")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    
                    // Header with dynamic title and date
                    if let puzzle = puzzleService.currentPuzzle {
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
                    } else {
                        Text("Today's Puzzle")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                    }
                    
                    // Loading state
                    if puzzleService.isLoading {
                        ProgressView("Loading puzzle...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                    }
                    
                    // Error state
                    if let errorMessage = puzzleService.errorMessage {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text("Error")
                                .font(.headline)
                            Text(errorMessage)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                    
                    // Letters display
                    if puzzleService.currentPuzzle != nil {
                        LetterDisplayView(letters: puzzleService.currentPuzzle!.letters, centerLetter: puzzleService.currentPuzzle!.centerLetter, puzzleDate: puzzleService.currentPuzzle!.date)
                            .padding(.horizontal, 20)
                        
                        // Stats
                        StatsView(puzzle: puzzleService.currentPuzzle!)
                            .padding(.horizontal, 20)
                        
                        // Word count table
                        WordCountTableView()
                            .padding(.horizontal, 20)
                        
                        // Prefix table
                        PrefixTableView()
                            .padding(.horizontal, 20)
                        
                        // Action buttons
                        HStack(spacing: 16) {
                            Button("Manual Input") {
                                showingManualInput = true
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button("Reveal All Words") {
                                showingAllWords = true
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.horizontal, 20)
                        
                        // Refresh button
                        Button(action: {
                            Task {
                                await puzzleService.fetchTodayPuzzle()
                                await puzzleService.fetchCacheStatus()
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Refresh")
                            }
                        }
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingManualInput) {
                ManualInputView()
                    .environmentObject(puzzleService)
            }
            .sheet(isPresented: $showingAllWords) {
                AllWordsView()
                    .environmentObject(puzzleService)
            }
            .onAppear {
                if puzzleService.currentPuzzle == nil {
                    Task {
                        await puzzleService.fetchTodayPuzzle()
                    }
                }
            }
        }
    }
    
    private func getHeaderTitle(for date: Date) -> String {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        
        // Debug: Print the dates to see what's happening
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        print("Puzzle date: \(dateFormatter.string(from: date))")
        print("Today: \(dateFormatter.string(from: today))")
        print("Yesterday: \(dateFormatter.string(from: yesterday))")
        
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

struct LetterDisplayView: View {
    let letters: [String]
    let centerLetter: String
    let puzzleDate: Date
    
    var body: some View {
        VStack(spacing: 16) {
            Text(getLettersTitle(for: puzzleDate))
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ForEach(letters, id: \.self) { letter in
                    LetterCircle(
                        letter: letter,
                        isCenter: letter == centerLetter
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func getLettersTitle(for date: Date) -> String {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        
        if calendar.isDate(date, inSameDayAs: today) {
            return "Today's Letters"
        } else if calendar.isDate(date, inSameDayAs: yesterday) {
            return "Yesterday's Letters"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayName = dateFormatter.string(from: date)
            return "\(dayName)'s Letters"
        }
    }
}

struct LetterCircle: View {
    let letter: String
    let isCenter: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isCenter ? Color.yellow : Color.blue)
                .frame(width: 44, height: 44)
            
            Text(letter)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

struct StatsView: View {
    let puzzle: PuzzleData
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                StatCard(title: "Total Words", value: "\(puzzle.totalWords)", color: .blue)
                StatCard(title: "Pangrams", value: "\(puzzle.totalPangrams)", color: .orange)
                StatCard(title: "Compound", value: "\(puzzle.totalCompoundWords)", color: .green)
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
} 