import SwiftUI

struct ManualInputView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @Environment(\.dismiss) private var dismiss
    @State private var letters: [String] = Array(repeating: "", count: 7)
    @State private var centerLetterIndex = 0
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingManualInput = true
    @FocusState private var focusedField: Int?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Expandable manual input section
                VStack(spacing: 10) {
                    // Header with expand/collapse button
                    HStack {
                        Text("Choose Your Letters")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(showingManualInput ? .primary : .white)
                        
                        Spacer()
                        
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showingManualInput.toggle()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: showingManualInput ? "xmark" : "pencil")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                            
                            }
                            .foregroundColor(showingManualInput ? .blue : .white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(showingManualInput ? Color.clear : Color.blue)
                    .cornerRadius(showingManualInput ? 0 : 12)
                    
                    // Manual input content
                    if showingManualInput {
                        VStack(spacing: 16) {
                            // Letter input fields
                            HStack {
                                ForEach(0..<7, id: \.self) { index in
                                    LetterInputField(
                                        letter: $letters[index],
                                        isCenter: index == centerLetterIndex,
                                        isFocused: focusedField == index,
                                        onLetterChanged: { newLetter in
                                            handleLetterInput(at: index, letter: newLetter)
                                        }
                                    )
                                    .focused($focusedField, equals: index)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Center letter selector
                            VStack(spacing: 12) {
                                Text("Tap to Set Center Letter")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                HStack(spacing: 8) {
                                    ForEach(0..<7, id: \.self) { index in
                                        CenterLetterButton(
                                            letter: letters[index],
                                            isSelected: index == centerLetterIndex,
                                            isEnabled: !letters[index].isEmpty,
                                            action: {
                                                if !letters[index].isEmpty {
                                                    centerLetterIndex = index
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Generate button
                            Button(action: submitLetters) {
                                HStack {
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
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(isValidInput ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .disabled(!isValidInput || puzzleService.isLoading)
                            .padding(.horizontal, 20)
                            
                            // Validation status
                            VStack(spacing: 8) {
                                if !letters.allSatisfy({ !$0.isEmpty }) {
                                    Text("Please enter all 7 letters")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                } else if !isValidPuzzle {
                                    Text("Invalid puzzle: Must have exactly 7 unique letters")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                } else {
                                    Text("✓ Valid puzzle ready")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 0)
                
                // Original Today view interface - only show if we have a puzzle
                if let puzzle = puzzleService.currentPuzzle {
                    // Letters display
                    LetterDisplayView(letters: puzzle.letters, centerLetter: puzzle.centerLetter, puzzleDate: puzzle.date)
                        .padding(.horizontal, 20)
                    
                    // Stats
                    StatsView(puzzle: puzzle)
                        .padding(.horizontal, 20)
                    
                    // Word count table
                    WordCountTableView()
                        .padding(.horizontal, 20)
                    
                    // Prefix table
                    PrefixTableView()
                        .padding(.horizontal, 20)
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        Button("New Puzzle") {
                            // Reset for new puzzle
                            letters = Array(repeating: "", count: 7)
                            centerLetterIndex = 0
                            puzzleService.currentPuzzle = nil
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showingManualInput = true
                            }
                            focusedField = 0
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Reveal All Words") {
                            // This would show all words
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal, 20)
                    
                    // Source info
                    if let source = puzzle.source {
                        Text("Source: \(source)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                    }
                }
                
                Spacer(minLength: 40)
            }
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            // Set initial focus
            focusedField = 0
        }
    }
    
    private var isValidInput: Bool {
        let nonEmptyLetters = letters.filter { !$0.isEmpty }
        return nonEmptyLetters.count == 7 && letters[centerLetterIndex].count == 1
    }
    
    private var isValidPuzzle: Bool {
        let nonEmptyLetters = letters.filter { !$0.isEmpty }
        let uniqueLetters = Set(nonEmptyLetters)
        return nonEmptyLetters.count == 7 && uniqueLetters.count == 7
    }
    
    private func handleLetterInput(at index: Int, letter: String) {
        // Convert to uppercase and ensure single character
        let upperLetter = letter.uppercased()
        let singleLetter = String(upperLetter.prefix(1))
        
        letters[index] = singleLetter
        
        // Auto-advance to next field if a letter was entered
        if !singleLetter.isEmpty && index < 6 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focusedField = index + 1
            }
        }
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
            // Slide up the manual input after generating
            withAnimation(.easeInOut(duration: 0.3)) {
                showingManualInput = false
            }
        }
    }
}

struct LetterInputField: View {
    @Binding var letter: String
    let isCenter: Bool
    let isFocused: Bool
    let onLetterChanged: (String) -> Void
    
    var body: some View {
        TextField("", text: $letter)
            .font(.title2)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isCenter ? Color.orange.opacity(0.2) : Color.blue.opacity(0.2))
                    .stroke(isFocused ? (isCenter ? Color.orange : Color.blue) : Color.gray, lineWidth: 1)
            )
            .onChange(of: letter) { newValue in
                onLetterChanged(newValue)
            }
    }
}

struct CenterLetterButton: View {
    let letter: String
    let isSelected: Bool
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(letter.isEmpty ? "?" : letter)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(isSelected ? Color.orange : (isEnabled ? Color.blue : Color.gray))
                )
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    ManualInputView()
        .environmentObject(PuzzleService())
}
