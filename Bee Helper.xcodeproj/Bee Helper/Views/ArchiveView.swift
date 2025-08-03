import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Date selector
                VStack(spacing: 15) {
                    Text("Select Date")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showingDatePicker = true
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.title2)
                            
                            Text(dateFormatter.string(from: selectedDate))
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
                
                // Quick date buttons
                VStack(spacing: 10) {
                    Text("Quick Select")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 15) {
                        QuickDateButton(title: "Yesterday", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
                        QuickDateButton(title: "Last Week", date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date())
                    }
                    
                    HStack(spacing: 15) {
                        QuickDateButton(title: "Last Month", date: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date())
                        QuickDateButton(title: "Random", date: randomDate())
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Puzzle display for selected date
                if let puzzle = puzzleService.currentPuzzle {
                    VStack(spacing: 15) {
                        Text("Puzzle for \(dateFormatter.string(from: puzzle.date))")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        // Letters display
                        HStack(spacing: 15) {
                            ForEach(puzzle.letters, id: \.self) { letter in
                                LetterCircle(
                                    letter: letter,
                                    isCenter: letter == puzzle.centerLetter
                                )
                            }
                        }
                        
                        // Stats
                        HStack(spacing: 20) {
                            StatCard(title: "Words", value: "\(puzzle.totalWords)")
                            StatCard(title: "Pangrams", value: "\(puzzle.totalPangrams)")
                            StatCard(title: "Compound", value: "\(puzzle.totalCompoundWords)")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
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
                
                Spacer()
            }
            .navigationTitle("Archive")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingDatePicker) {
                DatePickerView(selectedDate: $selectedDate)
            }
            .onChange(of: selectedDate) { _ in
                Task {
                    await puzzleService.fetchPuzzleForDate(selectedDate)
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private func randomDate() -> Date {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let endDate = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let timeInterval = endDate.timeIntervalSince(startDate)
        let randomTimeInterval = Double.random(in: 0...timeInterval)
        return startDate.addingTimeInterval(randomTimeInterval)
    }
}

struct QuickDateButton: View {
    let title: String
    let date: Date
    @EnvironmentObject var puzzleService: PuzzleService
    
    var body: some View {
        Button(action: {
            Task {
                await puzzleService.fetchPuzzleForDate(date)
            }
        }) {
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

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
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
            }
            .navigationTitle("Select Date")
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

#Preview {
    ArchiveView()
        .environmentObject(PuzzleService())
} 