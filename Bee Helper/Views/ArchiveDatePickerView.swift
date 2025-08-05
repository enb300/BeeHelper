import SwiftUI

struct ArchiveDatePickerView: View {
    @Binding var selectedDate: Date
    let onDateSelected: () -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var puzzleService: PuzzleService
    
    @State private var availableDates: Set<Date> = []
    @State private var isLoadingDates = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select a Date")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                if isLoadingDates {
                    ProgressView("Loading available dates...")
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                            ForEach(getDatesForCurrentMonth(), id: \.self) { date in
                                DateButton(
                                    date: date,
                                    isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                    isAvailable: availableDates.contains(date),
                                    onTap: {
                                        if availableDates.contains(date) {
                                            selectedDate = date
                                        }
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
                
                Button("Load Puzzle") {
                    onDateSelected()
                    dismiss()
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(availableDates.contains(selectedDate) ? Color.blue : Color.gray)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .disabled(!availableDates.contains(selectedDate))
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
        .onAppear {
            loadAvailableDates()
        }
    }
    
    private func getDatesForCurrentMonth() -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now
        
        var dates: [Date] = []
        var currentDate = startOfMonth
        
        while currentDate < endOfMonth {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    private func loadAvailableDates() {
        isLoadingDates = true
        
        // For now, we'll assume today and yesterday are available
        // In a real implementation, you'd check the server for available dates
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        
        availableDates = [today, yesterday]
        
        // Add a few more recent dates as available (for demo purposes)
        for i in 2...7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                availableDates.insert(date)
            }
        }
        
        isLoadingDates = false
    }
}

struct DateButton: View {
    let date: Date
    let isSelected: Bool
    let isAvailable: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                .foregroundColor(isAvailable ? (isSelected ? .white : .primary) : .secondary)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : (isAvailable ? Color.clear : Color.gray.opacity(0.3)))
                )
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
        }
        .disabled(!isAvailable)
    }
} 