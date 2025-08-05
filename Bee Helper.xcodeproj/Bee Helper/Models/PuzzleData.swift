import Foundation

struct PuzzleData: Codable, Identifiable {
    let id: UUID
    let date: Date
    let letters: [String]
    let centerLetter: String
    let words: [String]

    var totalWords: Int { words.count }
    var totalPangrams: Int { pangrams.count }
    var totalCompoundWords: Int { compoundWords.count }

    var pangrams: [String] {
        words.filter { word in
            let uniqueLetters = Set(word.lowercased())
            return uniqueLetters.count == 7 && word.count >= 4
        }
    }

    var compoundWords: [String] {
        words.filter { word in
            word.contains("-") || word.contains(" ")
        }
    }

    var wordCountByFirstLetter: [String: Int] {
        Dictionary(grouping: words, by: { String($0.prefix(1)).uppercased() })
            .mapValues { $0.count }
    }

    func wordCountByPrefix(prefixLength: Int) -> [String: Int] {
        let validWords = words.filter { $0.count >= prefixLength }
        return Dictionary(grouping: validWords, by: { String($0.prefix(prefixLength)).uppercased() })
            .mapValues { $0.count }
    }

    init(date: Date, letters: [String], centerLetter: String, words: [String]) {
        self.id = UUID()
        self.date = date
        self.letters = letters
        self.centerLetter = centerLetter
        self.words = words
    }
} 