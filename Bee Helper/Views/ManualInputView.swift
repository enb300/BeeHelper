import SwiftUI

struct ManualInputView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @Environment(\.dismiss) private var dismiss
    
    @State private var letters: [String] = Array(repeating: "", count: 7)
    @State private var centerLetterIndex = 0
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Instructions
                    VStack(spacing: 12) {
                        Text("Enter Today's Letters")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Enter the 7 letters from today's NYT Spelling Bee puzzle. Tap one letter to set it as the center letter.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    
                    // Letter input circles
                    VStack(spacing: 16) {
                        Text("Letters")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(0..<7, id: \.self) { index in
                                LetterInputCircle(
                                    letter: $letters[index],
                                    isCenter: index == centerLetterIndex,
                                    onTap: {
                                        centerLetterIndex = index
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Submit button
                    Button(action: submitLetters) {
                        HStack {
                            if puzzleService.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            
                            Text(puzzleService.isLoading ? "Generating Puzzle..." : "Generate Puzzle")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(puzzleService.isLoading ? Color.gray : Color.blue)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .disabled(puzzleService.isLoading || !isValidInput)
                    .padding(.horizontal, 20)
                    
                    if let errorMessage = puzzleService.errorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Manual Input")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Invalid Input", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var isValidInput: Bool {
        let filledLetters = letters.filter { !$0.isEmpty }
        return filledLetters.count == 7 && Set(filledLetters).count == 7
    }
    
    private func submitLetters() {
        guard isValidInput else {
            alertMessage = "Please enter exactly 7 different letters."
            showingAlert = true
            return
        }
        
        let centerLetter = letters[centerLetterIndex]
        
        Task {
            await puzzleService.generateCustomPuzzle(letters: letters, centerLetter: centerLetter)
            
            if puzzleService.errorMessage == nil {
                dismiss()
            }
        }
    }
}

struct LetterInputCircle: View {
    @Binding var letter: String
    let isCenter: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isCenter ? Color.yellow : Color.blue)
                    .frame(width: 56, height: 56)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                if letter.isEmpty {
                    Text("?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                } else {
                    Text(letter.uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(isCenter ? Color.orange : Color.clear, lineWidth: 3)
        )
    }
}

#Preview {
    ManualInputView()
        .environmentObject(PuzzleService())
} 