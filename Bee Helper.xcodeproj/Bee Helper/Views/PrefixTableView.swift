import SwiftUI

struct PrefixTableView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @State private var prefixLength = 2

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Text("Word Count by Prefix")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Prefix Length: \(prefixLength)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(prefixLength) letters")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Slider(value: Binding(
                    get: { Double(prefixLength) },
                    set: { prefixLength = Int($0) }
                ), in: 2...6, step: 1)
                .accentColor(.blue)
            }
            
            if let puzzle = puzzleService.currentPuzzle {
                let prefixData = puzzle.wordCountByPrefix(prefixLength: prefixLength)
                if !prefixData.isEmpty {
                    let groupedPrefixes = groupPrefixesByFirstLetter(prefixData)
                    LazyVStack(spacing: 16) {
                        ForEach(Array(groupedPrefixes.keys.sorted()), id: \.self) { firstLetter in
                            PrefixGroupCard(
                                firstLetter: firstLetter,
                                prefixes: groupedPrefixes[firstLetter] ?? []
                            )
                        }
                    }
                } else {
                    Text("No words found with \(prefixLength)-letter prefixes")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            } else {
                ProgressView()
                    .frame(height: 100)
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func groupPrefixesByFirstLetter(_ prefixData: [String: Int]) -> [String: [(String, Int)]] {
        var grouped: [String: [(String, Int)]] = [:]
        for (prefix, count) in prefixData {
            let firstLetter = String(prefix.prefix(1))
            if grouped[firstLetter] == nil {
                grouped[firstLetter] = []
            }
            grouped[firstLetter]?.append((prefix, count))
        }
        return grouped
    }
}

struct PrefixGroupCard: View {
    let firstLetter: String
    let prefixes: [(String, Int)]
    @EnvironmentObject var puzzleService: PuzzleService

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(firstLetter)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            let columns = getOptimalColumnCount()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 8) {
                ForEach(prefixes, id: \.0) { prefix, count in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(prefix)
                            .font(.headline)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                        
                        Text("(\(count))")
                            .font(.caption)
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
    
    private func getOptimalColumnCount() -> Int {
        let prefixLength = prefixes.first?.0.count ?? 2
        switch prefixLength {
        case 2: return 5
        case 3: return 4
        case 4: return 3
        default: return 2
        }
    }
} 