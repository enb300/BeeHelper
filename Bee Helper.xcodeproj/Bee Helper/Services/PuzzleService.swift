import Foundation
import SwiftUI

struct SpellingBeeResponse: Codable {
    let date: String
    let letters: [String]
    let centerLetter: String
    let words: [String]
    let stats: Stats
}

struct Stats: Codable {
    let totalWords: Int
    let totalPangrams: Int
    let totalCompoundWords: Int
}

@MainActor
class PuzzleService: ObservableObject {
    @Published var currentPuzzle: PuzzleData?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiBaseURL = "http://localhost:5001"

    init() {
        Task { await fetchTodayPuzzle() }
    }

    func fetchTodayPuzzle() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let url = URL(string: "\(apiBaseURL)/api/spelling-bee/today")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: response.date) ?? Date()
            
            currentPuzzle = PuzzleData(
                date: date,
                letters: response.letters,
                centerLetter: response.centerLetter,
                words: response.words
            )
        } catch {
            errorMessage = "Failed to fetch today's puzzle: \(error.localizedDescription)"
            currentPuzzle = getTodayPuzzle()
        }
        
        isLoading = false
    }

    func fetchYesterdayPuzzle() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let url = URL(string: "\(apiBaseURL)/api/spelling-bee/yesterday")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: response.date) ?? Date()
            
            currentPuzzle = PuzzleData(
                date: date,
                letters: response.letters,
                centerLetter: response.centerLetter,
                words: response.words
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
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            
            let responseDate = dateFormatter.date(from: response.date) ?? date
            
            currentPuzzle = PuzzleData(
                date: responseDate,
                letters: response.letters,
                centerLetter: response.centerLetter,
                words: response.words
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
                words: response.words
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
            words: ["delight", "delightful", "delightfully", "delightfulness", "delighted", "delighting", "delights", "delightedly", "delightful", "delightfully", "delightfulness"]
        )
    }
} 