import Foundation
import SwiftUI

class PuzzleService: ObservableObject {
    @Published var currentPuzzle: PuzzleData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let nytURL = "https://www.nytimes.com/puzzles/spelling-bee"
    private let sbsolverURL = "https://www.sbsolver.com"
    
    func fetchTodayPuzzle() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            // Try to fetch from NYT first
            if let puzzle = await fetchFromNYT() {
                await MainActor.run {
                    self.currentPuzzle = puzzle
                    self.isLoading = false
                }
                return
            }
            
            // Fallback to sbsolver.com
            if let puzzle = await fetchFromSBSolver() {
                await MainActor.run {
                    self.currentPuzzle = puzzle
                    self.isLoading = false
                }
                return
            }
            
            // If both fail, use sample data
            await MainActor.run {
                self.currentPuzzle = PuzzleData.sample
                self.isLoading = false
                self.errorMessage = "Could not fetch today's puzzle. Using sample data."
            }
            
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = "Failed to fetch puzzle: \(error.localizedDescription)"
            }
        }
    }
    
    private func fetchFromNYT() async -> PuzzleData? {
        guard let url = URL(string: nytURL) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let htmlString = String(data: data, encoding: .utf8) ?? ""
            
            // Parse the HTML to extract puzzle data
            // This is a simplified parser - in a real app you'd need more robust parsing
            return parseNYTHTML(htmlString)
        } catch {
            print("Failed to fetch from NYT: \(error)")
            return nil
        }
    }
    
    private func fetchFromSBSolver() async -> PuzzleData? {
        // For now, return nil as sbsolver.com might not have a public API
        // In a real implementation, you'd need to implement web scraping
        return nil
    }
    
    private func parseNYTHTML(_ html: String) -> PuzzleData? {
        // This is a simplified parser
        // In a real implementation, you'd use a proper HTML parser
        // For now, return sample data
        return PuzzleData.sample
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
        // In a real app, you'd fetch archived puzzles
        // For now, return sample data
        await MainActor.run {
            self.currentPuzzle = PuzzleData.sample
        }
    }
} 