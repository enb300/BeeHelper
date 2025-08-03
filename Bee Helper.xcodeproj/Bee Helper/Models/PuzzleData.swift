import Foundation

struct PuzzleData: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let letters: [Character]
    let centerLetter: Character
    let words: [String]
    let pangrams: [String]
    let compoundWords: [String]
    
    var totalWords: Int { words.count }
    var totalPangrams: Int { pangrams.count }
    var totalCompoundWords: Int { compoundWords.count }
    
    var wordCountByFirstLetter: [Character: Int] {
        Dictionary(grouping: words, by: { $0.first! })
            .mapValues { $0.count }
    }
    
    func wordCountByPrefix(prefixLength: Int) -> [String: Int] {
        let validWords = words.filter { $0.count >= prefixLength }
        return Dictionary(grouping: validWords, by: { String($0.prefix(prefixLength)) })
            .mapValues { $0.count }
    }
    
    init(date: Date, letters: [Character], centerLetter: Character, words: [String]) {
        self.date = date
        self.letters = letters
        self.centerLetter = centerLetter
        self.words = words
        
        // Calculate pangrams (words using all 7 letters)
        self.pangrams = words.filter { word in
            let wordSet = Set(word.lowercased())
            let letterSet = Set(letters.map { $0.lowercased() })
            return wordSet == letterSet
        }
        
        // Calculate compound words (words that can be split into two valid words)
        self.compoundWords = words.filter { word in
            guard word.count >= 4 else { return false }
            for i in 1..<word.count {
                let firstPart = String(word.prefix(i))
                let secondPart = String(word.suffix(from: word.index(word.startIndex, offsetBy: i)))
                if words.contains(firstPart) && words.contains(secondPart) {
                    return true
                }
            }
            return false
        }
    }
}

// Sample data for testing
extension PuzzleData {
    static let sample = PuzzleData(
        date: Date(),
        letters: ["A", "E", "G", "I", "N", "R", "T"],
        centerLetter: "A",
        words: [
            "AGAIN", "AGAINST", "AIR", "ANGER", "ANGLE", "ANT", "AREA", "ARENA",
            "ARGUE", "ARISE", "ART", "ATE", "EARN", "EAT", "ERA", "GAIN", "GATE",
            "GEAR", "GET", "GIANT", "GRAIN", "GRANT", "GREAT", "GRIT", "GRUNT",
            "INGRAIN", "IRATE", "NEAR", "NEAT", "RAGE", "RAIN", "RATE", "RENT",
            "RING", "RITE", "TANGENT", "TANGIER", "TARGET", "TEAR", "TEEN",
            "TENANT", "TENT", "TIER", "TIGER", "TRAIN", "TREAT", "TREE", "TRIANGLE"
        ]
    )
} 