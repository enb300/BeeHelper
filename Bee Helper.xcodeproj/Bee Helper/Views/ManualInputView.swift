import SwiftUI

struct ManualInputView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @Environment(\.dismiss) private var dismiss
    
    @State private var letters: [Character] = Array(repeating: " ", count: 7)
    @State private var selectedCenterIndex = 0
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Title
                Text("Enter Today's Letters")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Instructions
                Text("Enter the 7 letters from today's puzzle. Tap a letter to make it the center letter.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Letter input grid
                VStack(spacing: 20) {
                    Text("Letters")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 15) {
                        ForEach(0..<7, id: \.self) { index in
                            LetterInputCircle(
                                letter: $letters[index],
                                isSelected: selectedCenterIndex == index,
                                onTap: {
                                    selectedCenterIndex = index
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Center letter indicator
                VStack(spacing: 10) {
                    Text("Center Letter")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(String(letters[selectedCenterIndex]))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .frame(width: 60, height: 60)
                        .background(Color.yellow.opacity(0.3))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                // Submit button
                Button(action: submitLetters) {
                    Text("Create Puzzle")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canSubmit ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!canSubmit)
                .padding(.horizontal)
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
        .alert("Invalid Input", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var canSubmit: Bool {
        letters.allSatisfy { $0 != " " } && letters.count == 7
    }
    
    private func submitLetters() {
        // Validate input
        let uniqueLetters = Set(letters.map { $0.uppercased() })
        guard uniqueLetters.count == 7 else {
            errorMessage = "Please enter exactly 7 unique letters."
            showingError = true
            return
        }
        
        let centerLetter = letters[selectedCenterIndex]
        let allLetters = letters.map { $0.uppercased() }
        
        puzzleService.createPuzzleFromManualInput(
            letters: allLetters,
            centerLetter: centerLetter.uppercased()
        )
        
        dismiss()
    }
}

struct LetterInputCircle: View {
    @Binding var letter: Character
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.yellow : Color.blue)
                    .frame(width: 50, height: 50)
                
                if letter == " " {
                    Text("?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                } else {
                    Text(String(letter))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            // Show keyboard for letter input
            // In a real app, you'd implement a custom keyboard or text field
            // For now, we'll use a simple approach
            withAnimation {
                letter = "A" // Default letter, in real app would show keyboard
            }
        }
    }
}

#Preview {
    ManualInputView()
        .environmentObject(PuzzleService())
} 