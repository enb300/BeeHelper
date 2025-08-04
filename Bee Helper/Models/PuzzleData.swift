import Foundation

struct PuzzleData: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let letters: [String]
    let centerLetter: String
    let words: [String]
    
    // Computed properties for statistics
    var totalWords: Int { words.count }
    
    var totalPangrams: Int { pangrams.count }
    
    var totalCompoundWords: Int { compoundWords.count }
    
    var pangrams: [String] {
        words.filter { word in
            let wordSet = Set(word.lowercased().map { String($0) })
            let letterSet = Set(letters.map { $0.lowercased() })
            return wordSet == letterSet
        }
    }
    
    var compoundWords: [String] {
        words.filter { word in
            // Simple compound word detection - words that can be split into two valid words
            // This is a simplified version - in a real app you'd use a dictionary
            let wordLower = word.lowercased()
            for i in 1..<wordLower.count {
                let firstPart = String(wordLower.prefix(i))
                let secondPart = String(wordLower.suffix(from: wordLower.index(wordLower.startIndex, offsetBy: i)))
                if firstPart.count >= 3 && secondPart.count >= 3 {
                    // Check if both parts are valid words (simplified)
                    if words.contains(firstPart.uppercased()) && words.contains(secondPart.uppercased()) {
                        return true
                    }
                }
            }
            return false
        }
    }
    
    var wordCountByFirstLetter: [String: Int] {
        Dictionary(grouping: words, by: { String($0.prefix(1)) })
            .mapValues { $0.count }
    }
    
    func wordCountByPrefix(prefixLength: Int) -> [String: Int] {
        let prefixes = words.compactMap { word -> String? in
            guard word.count >= prefixLength else { return nil }
            return String(word.prefix(prefixLength)).uppercased()
        }
        
        return Dictionary(grouping: prefixes, by: { $0 })
            .mapValues { $0.count }
    }
    
    init(date: Date, letters: [String], centerLetter: String, words: [String]) {
        self.date = date
        self.letters = letters
        self.centerLetter = centerLetter
        self.words = words
    }
}

// API Response Models
struct SpellingBeeResponse: Codable {
    let date: String
    let center_letter: String
    let letters: [String]
    let words: [String]
    let stats: Stats
}

struct Stats: Codable {
    let total_words: Int
    let pangram_count: Int
    let compound_count: Int
    let word_count_by_letter: [String: Int]
    let prefix_tally_2: [String: Int]
} 