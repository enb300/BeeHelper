import Foundation

class DictionaryService: ObservableObject {
    private var dictionary: Set<String> = []
    private var isLoaded = false
    
    init() {
        loadDictionary()
    }
    
    private func loadDictionary() {
        // Start with a basic dictionary of common words
        let basicWords = [
            "THE", "AND", "FOR", "ARE", "BUT", "NOT", "YOU", "ALL", "CAN", "HER", "WAS", "ONE", "OUR", "OUT", "DAY", "GET", "HAS", "HIM", "HIS", "HOW", "MAN", "NEW", "NOW", "OLD", "SEE", "TWO", "WAY", "WHO", "BOY", "DID", "ITS", "LET", "PUT", "SAY", "SHE", "TOO", "USE",
            "ABOUT", "AFTER", "AGAIN", "AGAINST", "ALONG", "AMONG", "ANOTHER", "ANSWER", "AROUND", "BEFORE", "BEHIND", "BETWEEN", "BETTER", "BRING", "BUILD", "CALLED", "CAME", "CARRY", "CHANGE", "COME", "COULD", "EACH", "EVEN", "EVERY", "FIND", "FIRST", "FOUND", "FROM", "GIVE", "GOES", "GOOD", "GREAT", "HAD", "HAS", "HAVE", "HERE", "HIGH", "INTO", "JUST", "KNOW", "LARGE", "LITTLE", "LONG", "LOOK", "MADE", "MAKE", "MANY", "MIGHT", "MORE", "MOST", "MOVE", "MUCH", "MUST", "NAME", "NEAR", "NEVER", "NEXT", "ONLY", "OVER", "PART", "PEOPLE", "PLACE", "RIGHT", "SAID", "SAME", "SEEM", "SHOULD", "SMALL", "SOUND", "STILL", "SUCH", "TAKE", "TELL", "THAN", "THAT", "THEIR", "THEM", "THEN", "THERE", "THEY", "THING", "THINK", "THIS", "THOSE", "THROUGH", "TIME", "UNDER", "VERY", "WANT", "WELL", "WENT", "WERE", "WHAT", "WHEN", "WHERE", "WHICH", "WHILE", "WHO", "WILL", "WITH", "WORD", "WORK", "WORLD", "WOULD", "YEAR", "YOUR",
            // Add spelling bee specific words for testing
            "ALIEN", "ALINE", "ALOIN", "ANILE", "ANOLE", "ANTLE", "ELAIN", "ELOIN", "ENTIA", "INLET", "LATEN", "LEANT", "LENTO", "LIANE", "LIENT", "LINEN", "LITEN", "LOAN", "NAIL", "NEAT", "NITE", "NOEL", "NOIL", "OLEIN", "TALON", "TINE", "TOIL", "TONE"
        ]
        
        dictionary = Set(basicWords)
        isLoaded = true
        print("Loaded \(dictionary.count) basic words for offline use")
    }
    
    func isValidWord(_ word: String) -> Bool {
        return dictionary.contains(word.uppercased())
    }
    
    func generateSpellingBeeWords(letters: [String], centerLetter: String) -> [String] {
        let letterSet = Set(letters.map { $0.uppercased() })
        var validWords: [String] = []
        
        for word in dictionary {
            let wordUpper = word.uppercased()
            
            // Check if word uses only the given letters
            let wordLetters = Set(wordUpper)
            if !wordLetters.isSubset(of: letterSet) {
                continue
            }
            
            // Check if word contains center letter
            if !wordUpper.contains(centerLetter.uppercased()) {
                continue
            }
            
            // Check minimum length (4 letters)
            if wordUpper.count < 4 {
                continue
            }
            
            validWords.append(wordUpper)
        }
        
        return validWords.sorted()
    }
    
    func getFallbackPuzzle() -> PuzzleData {
        // Return a simple fallback puzzle for testing with known pangrams
        let letters = ["A", "E", "I", "L", "N", "O", "T"]
        let centerLetter = "E"
        let words = generateSpellingBeeWords(letters: letters, centerLetter: centerLetter)
        
        // Add some known pangrams to the basic dictionary for testing
        let additionalWords = ["ALIEN", "ALINE", "ALOIN", "ANILE", "ANOLE", "ANTLE", "ELAIN", "ELOIN", "ENTIA", "INLET", "LATEN", "LEANT", "LENTO", "LIANE", "LIENT", "LINEN", "LITEN", "LOAN", "NAIL", "NEAT", "NITE", "NOEL", "NOIL", "OLEIN", "TALON", "TINE", "TOIL", "TONE"]
        
        var allWords = Set(words)
        allWords.formUnion(additionalWords)
        
        return PuzzleData(
            date: Date(),
            letters: letters,
            centerLetter: centerLetter,
            words: Array(allWords).sorted(),
            source: "offline"
        )
    }
} 