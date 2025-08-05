import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Text("Puzzle Archive")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Browse past NYT Spelling Bee puzzles")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                
                // Quick access buttons
                VStack(spacing: 16) {
                    Button(action: {
                        Task {
                            await puzzleService.fetchTodayPuzzle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(.orange)
                            Text("Today's Puzzle")
                                .fontWeight(.semibold)
                            Spacer()
                            if puzzleService.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .disabled(puzzleService.isLoading)
                    
                    Button(action: {
                        Task {
                            await puzzleService.fetchYesterdayPuzzle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            Text("Yesterday's Puzzle")
                                .fontWeight(.semibold)
                            Spacer()
                            if puzzleService.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .disabled(puzzleService.isLoading)
                    
                    Button(action: {
                        showingDatePicker = true
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.green)
                            Text("Pick a Date")
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                
                // Current puzzle display
                if let puzzle = puzzleService.currentPuzzle {
                    VStack(spacing: 16) {
                        Text("Selected Puzzle")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            // Date
                            Text(puzzle.date, style: .date)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            // Letters
                            HStack(spacing: 8) {
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
                                StatItem(title: "Compounds", value: "\(puzzle.totalCompoundWords)")
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Error message
                if let errorMessage = puzzleService.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .navigationTitle("Archive")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate) {
                Task {
                    await puzzleService.fetchArchivePuzzle(for: selectedDate)
                }
            }
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    let onDateSelected: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select a Date")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Button("Load Puzzle") {
                    onDateSelected()
                    dismiss()
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
            .navigationTitle("Date Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
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
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ArchiveView()
        .environmentObject(PuzzleService())
} 
