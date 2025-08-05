import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    @State private var showingPuzzleDetail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Quick access buttons
                VStack(spacing: 15) {
                    Text("Quick Access")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 15) {
                        QuickAccessButton(title: "Today's Puzzle", action: {
                            Task {
                                await puzzleService.fetchTodayPuzzle()
                            }
                        })
                        
                        QuickAccessButton(title: "Yesterday's Puzzle", action: {
                            Task {
                                await puzzleService.fetchYesterdayPuzzle()
                            }
                        })
                    }
                    
                    Button(action: {
                        showingDatePicker = true
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.title2)
                            
                            Text("Pick a Date")
                                .font(.title3)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                // Current puzzle display
                Text("🔥 DEBUG: puzzleService.currentPuzzle is \(puzzleService.currentPuzzle == nil ? "nil" : "not nil") 🔥")
                    .foregroundColor(.red)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(8)
                
                if let puzzle = puzzleService.currentPuzzle {
                    VStack(spacing: 20) {
                        // Puzzle content
                        VStack(spacing: 20) {
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
                            
                            // Letters display
                            HStack(spacing: 12) {
                                ForEach(puzzle.letters, id: \.self) { letter in
                                    LetterCircle(
                                        letter: letter,
                                        isCenter: letter == puzzle.centerLetter
                                    )
                                }
                            }
                            
                            // Stats
                            HStack(spacing: 20) {
                                StatItem(title: "Words", value: "\(puzzle.totalWords)")
                                StatItem(title: "Pangrams", value: "\(puzzle.totalPangrams)")
                                StatItem(title: "Compound", value: "\(puzzle.totalCompoundWords)")
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // DEBUG: Add a simple text to see if this section is being rendered
                        Text("DEBUG: Button should be below this text")
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        // Simple VIEW PUZZLE button
                        Button(action: {
                            print("VIEW PUZZLE button tapped!")
                            showingPuzzleDetail = true
                        }) {
                            HStack {
                                Image(systemName: "eye.fill")
                                    .font(.title2)
                                Text("VIEW PUZZLE")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red) // Changed to red to make it more obvious
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    VStack(spacing: 15) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("Select a date to view archived puzzle")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Puzzle data may not be available for all dates")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
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
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Archive")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingDatePicker) {
                DatePickerView(selectedDate: $selectedDate) {
                    Task {
                        await puzzleService.fetchArchivePuzzle(for: selectedDate)
                    }
                }
            }
            .sheet(isPresented: $showingPuzzleDetail) {
                if let puzzle = puzzleService.currentPuzzle {
                    ArchivePuzzleDetailView(puzzle: puzzle)
                        .environmentObject(puzzleService)
                }
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
    
    private func navigateToPreviousDay() {
        guard let currentPuzzle = puzzleService.currentPuzzle else { return }
        let calendar = Calendar.current
        let previousDay = calendar.date(byAdding: .day, value: -1, to: currentPuzzle.date) ?? currentPuzzle.date
        
        Task {
            await puzzleService.fetchArchivePuzzle(for: previousDay)
        }
    }
    
    private func navigateToNextDay() {
        guard let currentPuzzle = puzzleService.currentPuzzle else { return }
        let calendar = Calendar.current
        let nextDay = calendar.date(byAdding: .day, value: 1, to: currentPuzzle.date) ?? currentPuzzle.date
        
        // Don't navigate to future dates
        let today = Date()
        if nextDay <= today {
            Task {
                await puzzleService.fetchArchivePuzzle(for: nextDay)
            }
        }
    }
    
}

struct QuickAccessButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.blue)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    let onDateSelected: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .padding()
                
                Spacer()
                
                Button("Load Puzzle") {
                    onDateSelected()
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.bottom, 20)
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
            .environmentObject(PuzzleService())
    }
} 