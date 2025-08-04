import SwiftUI

struct TodayView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @State private var showingManualInput = false
    @State private var showingAllWords = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header with refresh button
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today's Puzzle")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(Date().formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await puzzleService.fetchTodayPuzzle()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .disabled(puzzleService.isLoading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Loading state
                    if puzzleService.isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                            
                            Text("Fetching today's puzzle...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else if let puzzle = puzzleService.currentPuzzle {
                        // Letters display
                        LetterDisplayView()
                            .padding(.horizontal, 20)
                        
                        // Stats cards
                        StatsView()
                            .padding(.horizontal, 20)
                        
                        // Word count table
                        WordCountTableView()
                            .padding(.horizontal, 20)
                        
                        // Prefix table
                        PrefixTableView()
                            .padding(.horizontal, 20)
                        
                        // Action buttons
                        VStack(spacing: 16) {
                            Button(action: {
                                showingManualInput = true
                            }) {
                                HStack {
                                    Image(systemName: "keyboard")
                                        .font(.title3)
                                    
                                    Text("Enter Letters Manually")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingAllWords = true
                            }) {
                                HStack {
                                    Image(systemName: "eye")
                                        .font(.title3)
                                    
                                    Text("Show All Words")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                    } else {
                        // Error state
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)
                            
                            Text("Unable to load puzzle")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            if let errorMessage = puzzleService.errorMessage {
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                            
                            Button(action: {
                                Task {
                                    await puzzleService.fetchTodayPuzzle()
                                }
                            }) {
                                Text("Try Again")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 40)
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

struct LetterDisplayView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Today's Letters")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            if let puzzle = puzzleService.currentPuzzle {
                HStack(spacing: 8) {
                    ForEach(puzzle.letters, id: \.self) { letter in
                        LetterCircle(
                            letter: letter,
                            isCenter: letter == puzzle.centerLetter
                        )
                    }
                }
            } else {
                Text("Loading letters...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
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
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            Text(letter)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

struct StatsView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Puzzle Stats")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            if let puzzle = puzzleService.currentPuzzle {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    StatCard(title: "Total Words", value: "\(puzzle.totalWords)", color: .blue)
                    StatCard(title: "Pangrams", value: "\(puzzle.totalPangrams)", color: .orange)
                    StatCard(title: "Compound Words", value: "\(puzzle.totalCompoundWords)", color: .green)
                }
            } else {
                Text("Loading stats...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
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
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    TodayView()
        .environmentObject(PuzzleService())
} 