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
            VStack(spacing: 20) {
                Text("Enter Today's Letters")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Enter the 7 letters from today's puzzle. The center letter will be highlighted.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Letter input grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
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
                .padding(.horizontal)
                
                // Center letter selector
                HStack {
                    Text("Center Letter:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(letters[centerLetterIndex].isEmpty ? "?" : letters[centerLetterIndex])
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.yellow.opacity(0.3)))
                }
                
                Spacer()
                
                // Generate button
                Button(action: submitLetters) {
                    if puzzleService.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Generate Puzzle")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
                .disabled(!isValidInput || puzzleService.isLoading)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isValidInput ? Color.blue : Color.gray)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
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
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var isValidInput: Bool {
        let nonEmptyLetters = letters.filter { !$0.isEmpty }
        return nonEmptyLetters.count == 7 && letters[centerLetterIndex].count == 1
    }
    
    private func submitLetters() {
        guard isValidInput else {
            alertMessage = "Please enter exactly 7 letters and select a center letter."
            showingAlert = true
            return
        }
        
        let centerLetter = letters[centerLetterIndex]
        let allLetters = letters.filter { !$0.isEmpty }
        
        Task {
            await puzzleService.generateCustomPuzzle(letters: allLetters, centerLetter: centerLetter)
            dismiss()
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
                    .frame(width: 60, height: 60)
                
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
            RoundedRectangle(cornerRadius: 30)
                .stroke(isCenter ? Color.yellow : Color.clear, lineWidth: 3)
        )
        .onTapGesture {
            // Focus the text field
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
            // Handle keyboard
        }
    }
}
