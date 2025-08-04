import Foundation
import SwiftUI

@MainActor
class PuzzleService: ObservableObject {
    @Published var currentPuzzle: PuzzleData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiBaseURL = "http://localhost:5001"
    
    init() {
        Task {
            await fetchTodayPuzzle()
        }
    }
    
    func fetchTodayPuzzle() async {
        isLoading = true
        errorMessage = nil
        
        do {
            guard let url = URL(string: "\(apiBaseURL)/api/spelling-bee/today") else {
                errorMessage = "Invalid URL"
                isLoading = false
                return
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Server error"
                isLoading = false
                return
            }
            
            let apiResponse = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            
            // Convert API response to PuzzleData
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let puzzleDate = dateFormatter.date(from: apiResponse.date) ?? Date()
            
            let puzzleData = PuzzleData(
                date: puzzleDate,
                letters: apiResponse.letters,
                centerLetter: apiResponse.center_letter,
                words: apiResponse.words
            )
            
            currentPuzzle = puzzleData
            isLoading = false
            
        } catch {
            errorMessage = "Failed to fetch puzzle: \(error.localizedDescription)"
            isLoading = false
            
            // Fallback to sample data if API fails
            currentPuzzle = getTodayPuzzle()
        }
    }
    
    func fetchYesterdayPuzzle() async {
        isLoading = true
        errorMessage = nil
        
        do {
            guard let url = URL(string: "\(apiBaseURL)/api/spelling-bee/yesterday") else {
                errorMessage = "Invalid URL"
                isLoading = false
                return
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Server error"
                isLoading = false
                return
            }
            
            let apiResponse = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            
            // Convert API response to PuzzleData
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let puzzleDate = dateFormatter.date(from: apiResponse.date) ?? Date()
            
            let puzzleData = PuzzleData(
                date: puzzleDate,
                letters: apiResponse.letters,
                centerLetter: apiResponse.center_letter,
                words: apiResponse.words
            )
            
            currentPuzzle = puzzleData
            isLoading = false
            
        } catch {
            errorMessage = "Failed to fetch yesterday's puzzle: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func fetchArchivePuzzle(for date: Date) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            
            guard let url = URL(string: "\(apiBaseURL)/api/spelling-bee/archive/\(dateString)") else {
                errorMessage = "Invalid URL"
                isLoading = false
                return
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Server error"
                isLoading = false
                return
            }
            
            let apiResponse = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            
            // Convert API response to PuzzleData
            let puzzleDate = dateFormatter.date(from: apiResponse.date) ?? date
            
            let puzzleData = PuzzleData(
                date: puzzleDate,
                letters: apiResponse.letters,
                centerLetter: apiResponse.center_letter,
                words: apiResponse.words
            )
            
            currentPuzzle = puzzleData
            isLoading = false
            
        } catch {
            errorMessage = "Failed to fetch archive puzzle: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func generateCustomPuzzle(letters: [String], centerLetter: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let lettersString = letters.joined()
            guard let url = URL(string: "\(apiBaseURL)/api/spelling-bee/generate?letters=\(lettersString)&center=\(centerLetter)") else {
                errorMessage = "Invalid URL"
                isLoading = false
                return
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Server error"
                isLoading = false
                return
            }
            
            let apiResponse = try JSONDecoder().decode(SpellingBeeResponse.self, from: data)
            
            // Convert API response to PuzzleData
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let puzzleDate = dateFormatter.date(from: apiResponse.date) ?? Date()
            
            let puzzleData = PuzzleData(
                date: puzzleDate,
                letters: apiResponse.letters,
                centerLetter: apiResponse.center_letter,
                words: apiResponse.words
            )
            
            currentPuzzle = puzzleData
            isLoading = false
            
        } catch {
            errorMessage = "Failed to generate puzzle: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    private func getTodayPuzzle() -> PuzzleData {
        // Fallback sample data if API is unavailable
        let letters = ["A", "E", "G", "L", "N", "O", "Y"]
        let centerLetter = "E"
        
        let words = [
            "AEON", "AGELONG", "ALGAE", "ALLEGE", "ALLELE", "ALLEY", "ALOE", "ALONE", "ANGEL", "ANGLE",
            "ANNEAL", "ANYONE", "EAGLE", "EELY", "EGGNOG", "EGGY", "ELAN", "ELEGY", "ENGAGE", "GAGE",
            "GAGGLE", "GALE", "GALLEON", "GALLEY", "GELEE", "GENE", "GEOLOGY", "GLEAN", "GLEE", "GLEN",
            "GOGGLE", "GONE", "GOOEY", "GOOGLE", "LANE", "LEAN", "LEANLY", "LEGAL", "LEGALLY", "LEGGY",
            "LOGE", "LONE", "LONELY", "NENE", "NEON", "NOEL", "NONE", "OENOLOGY", "OGEE", "OGLE", "OLEO",
            "YELL", "GENEALOGY"
        ]
        
        return PuzzleData(
            date: Date(),
            letters: letters,
            centerLetter: centerLetter,
            words: words
        )
    }
    
    func createPuzzleFromManualInput(letters: [String], centerLetter: String) {
        // For manual input, we'll need to fetch word list from a dictionary API
        // For now, use sample words that match the input letters
        let sampleWords = [
            "AGAIN", "AGAINST", "AIR", "ANGER", "ANGLE", "ANT", "AREA", "ARENA",
            "ARGUE", "ARISE", "ART", "ATE", "EARN", "EAT", "ERA", "GAIN", "GATE",
            "GEAR", "GET", "GIANT", "GRAIN", "GRANT", "GREAT", "GRIT", "GRUNT"
        ]
        
        let validWords = sampleWords.filter { word in
            let wordSet = Set(word.uppercased().map { String($0) })
            let letterSet = Set(letters.map { $0.uppercased() })
            return wordSet.isSubset(of: letterSet) && word.contains(centerLetter.uppercased())
        }
        
        currentPuzzle = PuzzleData(
            date: Date(),
            letters: letters,
            centerLetter: centerLetter,
            words: validWords
        )
    }
    
    func fetchPuzzleForDate(_ date: Date) async {
        // In a real app, you'd fetch archived puzzles from SBSolver
        // For now, return today's puzzle data with the requested date
        await MainActor.run {
            self.currentPuzzle = getTodayPuzzle()
        }
    }
} 