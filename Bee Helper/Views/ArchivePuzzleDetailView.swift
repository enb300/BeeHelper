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
                    VStack(spacing: 16) {
                        Text(getLettersTitle(for: puzzle.date))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            ForEach(puzzle.letters, id: \.self) { letter in
                                ZStack {
                                    Circle()
                                        .fill(letter == puzzle.centerLetter ? Color.yellow : Color.blue)
                                        .frame(width: 44, height: 44)
                                    
                                    Text(letter)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // Stats
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



#Preview {
    let samplePuzzle = PuzzleData(
        date: Date(),
        letters: ["A", "B", "C", "D", "E", "F", "G"],
        centerLetter: "A",
        words: ["ABC", "DEF", "GHI"]
    )
    
    return ArchivePuzzleDetailView(puzzle: samplePuzzle)
        .environmentObject(PuzzleService())
} 