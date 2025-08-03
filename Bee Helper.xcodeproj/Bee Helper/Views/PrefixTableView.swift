import SwiftUI

struct PrefixTableView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @Binding var prefixLength: Int
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Word Count by Prefix")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let puzzle = puzzleService.currentPuzzle {
                VStack(spacing: 10) {
                    // Prefix length slider
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Prefix Length: \(prefixLength)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Slider(value: Binding(
                            get: { Double(prefixLength) },
                            set: { prefixLength = Int($0) }
                        ), in: 2...6, step: 1)
                        .accentColor(.blue)
                    }
                    .padding(.horizontal)
                    
                    // Prefix table
                    PrefixTableContent(puzzle: puzzle, prefixLength: prefixLength)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            } else {
                Text("Loading prefix data...")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PrefixTableContent: View {
    let puzzle: PuzzleData
    let prefixLength: Int
    
    var body: some View {
        let prefixCounts = puzzle.wordCountByPrefix(prefixLength: prefixLength)
        let sortedPrefixes = prefixCounts.keys.sorted()
        
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(sortedPrefixes, id: \.self) { prefix in
                    VStack(spacing: 5) {
                        Text(prefix)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("\(prefixCounts[prefix] ?? 0)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                }
            }
        }
        .frame(maxHeight: 200)
    }
}

#Preview {
    PrefixTableView(prefixLength: .constant(2))
        .environmentObject(PuzzleService())
} 