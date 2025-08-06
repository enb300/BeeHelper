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

    private let apiBaseURL = "https://bee-helper-api.onrender.com"
    
    struct CacheStatus: Codable {
        let cachedPuzzles: Int
        let cacheDates: [String]
        let dictionarySize: Int
        let cacheFile: String
    }

    init() {
        Task {
            await testJSONDecoding() // Test JSON decoding first
            await fetchTodayPuzzle()
            await fetchCacheStatus()
        }
    }

    func fetchTodayPuzzle() async {
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
            errorMessage = "Failed to fetch today's puzzle: \(error.localizedDescription)"
            // Try fallback puzzle if network fails
            currentPuzzle = getTodayPuzzle()
        }
        
        isLoading = false
    }
    
    func fetchCacheStatus() async {
        do {
            let url = URL(string: "\(apiBaseURL)/api/spelling-bee/cache")!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    return
                }
            }
            
            cacheStatus = try JSONDecoder().decode(CacheStatus.self, from: data)
        } catch {
            // Cache status is not critical, so we don't show errors
            print("Could not fetch cache status: \(error)")
        }
    }
    
    func testJSONDecoding() async {
        // Test with a simple JSON that matches our structure
        let testJSON = """
        {
            "date": "2025-08-05",
            "center_letter": "N",
            "letters": ["E", "N", "V", "C", "U", "O", "R"],
            "words": ["CEROON", "COCOON", "CONCERN"],
            "stats": {
                "total_words": 3,
                "pangram_count": 1,
                "compound_count": 0
            },
            "source": "test"
        }
        """
        
        do {
            let data = testJSON.data(using: .utf8)!
            let response = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            print("✅ JSON decoding test successful!")
            print("Decoded: \(response.date), \(response.centerLetter), \(response.words.count) words")
        } catch {
            print("❌ JSON decoding test failed: \(error)")
        }
    }

    func fetchYesterdayPuzzle() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let url = URL(string: "\(apiBaseURL)/api/spelling-bee/yesterday")!
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
            errorMessage = "Failed to fetch yesterday's puzzle: \(error.localizedDescription)"
        }
        
        isLoading = false
    }

    func fetchArchivePuzzle(for date: Date) async {
        isLoading = true
        errorMessage = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        do {
            let url = URL(string: "\(apiBaseURL)/api/spelling-bee/archive/\(dateString)")!
            let (data, httpResponse) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = httpResponse as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    throw URLError(.badServerResponse)
                }
            }
            
            let response = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            
            let responseDate = dateFormatter.date(from: response.date) ?? date
            
            currentPuzzle = PuzzleData(
                date: responseDate,
                letters: response.letters,
                centerLetter: response.centerLetter,
                words: response.words,
                source: response.source
            )
        } catch {
            errorMessage = "Failed to fetch archive puzzle: \(error.localizedDescription)"
        }
        
        isLoading = false
    }

    func generateCustomPuzzle(letters: [String], centerLetter: String) async {
        isLoading = true
        errorMessage = nil
        
        let lettersString = letters.joined()
        
        do {
            let url = URL(string: "\(apiBaseURL)/api/spelling-bee/generate?letters=\(lettersString)&center=\(centerLetter)")!
            let (data, _) = try await URLSession.shared.data(from: url)
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
            errorMessage = "Failed to generate puzzle: \(error.localizedDescription)"
        }
        
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
