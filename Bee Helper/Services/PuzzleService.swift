import Foundation
import SwiftUI

struct SpellingBeeResponse: Codable {
    let date: String
    let letters: [String]
    let centerLetter: String
    let words: [String]
    let stats: Stats
    let source: String?
    
    enum CodingKeys: String, CodingKey {
        case date, letters, words, stats, source
        case centerLetter = "center_letter"
    }
}

struct Stats: Codable {
    let totalWords: Int
    let totalPangrams: Int
    let totalCompoundWords: Int
    let prefixTally2: [String: Int]?
    let wordCountByLetter: [String: Int]?
    
    enum CodingKeys: String, CodingKey {
        case totalWords = "total_words"
        case totalPangrams = "pangram_count"
        case totalCompoundWords = "compound_count"
        case prefixTally2 = "prefix_tally_2"
        case wordCountByLetter = "word_count_by_letter"
    }
}

@MainActor
class PuzzleService: ObservableObject {
    @Published var currentPuzzle: PuzzleData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cacheStatus: CacheStatus?
    
    private let dictionaryService = DictionaryService()

    private let apiBaseURL = "http://localhost:5001"
    
    struct CacheStatus: Codable {
        let cachedPuzzles: Int
        let cacheDates: [String]
        let dictionarySize: Int
        let cacheFile: String
    }

    init() {
        // Start with a default puzzle instead of trying to fetch from API
        currentPuzzle = getDefaultPuzzle()
        Task {
            await fetchCacheStatus()
        }
    }
    
    private func getDefaultPuzzle() -> PuzzleData {
        // Create a default puzzle using the local dictionary
        let letters = ["A", "E", "I", "L", "N", "O", "T"]
        let centerLetter = "E"
        let words = dictionaryService.generateSpellingBeeWords(letters: letters, centerLetter: centerLetter)
        
        print("🔍 Default puzzle generated with \(words.count) words")
        print("📝 Sample words: \(Array(words.prefix(10)))")
        print("🔤 Letters: \(letters), Center: \(centerLetter)")
        
        return PuzzleData(
            date: Date(),
            letters: letters,
            centerLetter: centerLetter,
            words: words,
            source: "offline"
        )
    }

    func fetchTodayPuzzle() async {
        // This is now just a fallback - the app will work offline
        isLoading = true
        errorMessage = nil
        
        do {
            let url = URL(string: "\(apiBaseURL)/api/spelling-bee/today")!
            let (data, httpResponse) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = httpResponse as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    throw URLError(.badServerResponse)
                }
            }
            
            let response = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: response.date) ?? Date()
            
            currentPuzzle = PuzzleData(
                date: date,
                letters: response.letters,
                centerLetter: response.centerLetter,
                words: response.words,
                source: response.source
            )
        } catch {
            errorMessage = "Network unavailable - using offline mode"
            // Use default puzzle if network fails
            currentPuzzle = getDefaultPuzzle()
        }
        
        isLoading = false
    }
    
    func fetchCacheStatus() async {
        // Simplified cache status for offline mode
        cacheStatus = CacheStatus(
            cachedPuzzles: 0,
            cacheDates: [],
            dictionarySize: 0,
            cacheFile: "offline"
        )
    }

    func fetchArchivePuzzle(for date: Date) async {
        // Archive functionality disabled for offline mode
        errorMessage = "Archive puzzles not available in offline mode"
    }

    func generateCustomPuzzle(letters: [String], centerLetter: String) async {
        isLoading = true
        errorMessage = nil
        
        // Generate puzzle using local dictionary only
        let words = dictionaryService.generateSpellingBeeWords(letters: letters, centerLetter: centerLetter)
        
        currentPuzzle = PuzzleData(
            date: Date(),
            letters: letters,
            centerLetter: centerLetter,
            words: words,
            source: "manual_offline"
        )
        
        isLoading = false
    }

    private func getTodayPuzzle() -> PuzzleData {
        // Fallback sample data
        let today = Date()
        return PuzzleData(
            date: today,
            letters: ["T", "U", "L", "E", "I", "G", "D"],
            centerLetter: "E",
            words: ["delight", "delightful", "delightfully", "delightfulness", "delighted", "delighting", "delights", "delightedly", "delightful", "delightfully", "delightfulness"],
            source: "fallback"
        )
    }
}
