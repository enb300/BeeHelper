import Foundation

class DictionaryService: ObservableObject {
    private var dictionary: Set<String> = []
    private var isLoaded = false
    
    init() {
        loadDictionary()
    }
    
    private func loadDictionary() {
        let logMessage = "🔍 Starting dictionary load...\n"
        writeToLog(logMessage)
        
        // Try to load the comprehensive dictionary first
        if let dictPath = Bundle.main.path(forResource: "cleaned_scraped_words", ofType: "txt") {
            let foundMessage = "✅ Found dictionary file at: \(dictPath)\n"
            writeToLog(foundMessage)
            do {
                let content = try String(contentsOfFile: dictPath, encoding: .utf8)
                let words = content.components(separatedBy: .newlines)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
                    .filter { !$0.isEmpty && $0.count >= 4 }
                
                dictionary = Set(words)
                isLoaded = true
                let successMessage = "✅ Loaded \(dictionary.count) words from comprehensive dictionary\n"
                writeToLog(successMessage)
                let sampleMessage = "📝 Sample words: \(Array(dictionary.prefix(10)))\n"
                writeToLog(sampleMessage)
                return
            } catch {
                let errorMessage = "❌ Error loading comprehensive dictionary: \(error)\n"
                writeToLog(errorMessage)
            }
        } else {
            let notFoundMessage = "❌ Could not find cleaned_scraped_words.txt in app bundle\n"
            writeToLog(notFoundMessage)
            let bundleMessage = "🔍 Checking bundle contents...\n"
            writeToLog(bundleMessage)
            let bundlePath = Bundle.main.bundlePath
            let pathMessage = "📁 Bundle path: \(bundlePath)\n"
            writeToLog(pathMessage)
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: bundlePath)
                let contentsMessage = "📋 Bundle contents: \(contents)\n"
                writeToLog(contentsMessage)
            } catch {
                let listError = "❌ Could not list bundle contents: \(error)\n"
                writeToLog(listError)
            }
        }
        
        // Fallback to basic dictionary if comprehensive dictionary not found
        let fallbackMessage = "⚠️ Falling back to basic dictionary\n"
        writeToLog(fallbackMessage)
        let basicWords = [
            "THE", "AND", "FOR", "ARE", "BUT", "NOT", "YOU", "ALL", "CAN", "HER", "WAS", "ONE", "OUR", "OUT", "DAY", "GET", "HAS", "HIM", "HIS", "HOW", "MAN", "NEW", "NOW", "OLD", "SEE", "TWO", "WAY", "WHO", "BOY", "DID", "ITS", "LET", "PUT", "SAY", "SHE", "TOO", "USE",
            "ABOUT", "AFTER", "AGAIN", "AGAINST", "ALONG", "AMONG", "ANOTHER", "ANSWER", "AROUND", "BEFORE", "BEHIND", "BETWEEN", "BETTER", "BRING", "BUILD", "CALLED", "CAME", "CARRY", "CHANGE", "COME", "COULD", "EACH", "EVEN", "EVERY", "FIND", "FIRST", "FOUND", "FROM", "GIVE", "GOES", "GOOD", "GREAT", "HAD", "HAS", "HAVE", "HERE", "HIGH", "INTO", "JUST", "KNOW", "LARGE", "LITTLE", "LONG", "LOOK", "MADE", "MAKE", "MANY", "MIGHT", "MORE", "MOST", "MOVE", "MUCH", "MUST", "NAME", "NEAR", "NEVER", "NEXT", "ONLY", "OVER", "PART", "PEOPLE", "PLACE", "RIGHT", "SAID", "SAME", "SEEM", "SHOULD", "SMALL", "SOUND", "STILL", "SUCH", "TAKE", "TELL", "THAN", "THAT", "THEIR", "THEM", "THEN", "THERE", "THEY", "THING", "THINK", "THIS", "THOSE", "THROUGH", "TIME", "UNDER", "VERY", "WANT", "WELL", "WENT", "WERE", "WHAT", "WHEN", "WHERE", "WHICH", "WHILE", "WHO", "WILL", "WITH", "WORD", "WORK", "WORLD", "WOULD", "YEAR", "YOUR",
            // Add spelling bee specific words for testing - expanded for default puzzle letters A,E,I,L,N,O,T
            "ALIEN", "ALINE", "ALOIN", "ANILE", "ANOLE", "ANTLE", "ELAIN", "ELOIN", "ENTIA", "INLET", "LATEN", "LEANT", "LENTO", "LIANE", "LIENT", "LINEN", "LITEN", "LOAN", "NAIL", "NEAT", "NITE", "NOEL", "NOIL", "OLEIN", "TALON", "TINE", "TOIL", "TONE",
            // Additional words for A,E,I,L,N,O,T puzzle
            "AIL", "AILED", "AILING", "AINT", "ALE", "ALIEN", "ALINE", "ALOIN", "ANILE", "ANOLE", "ANTLE", "ANT", "ATE", "EAT", "EATEN", "EATING", "ELAIN", "ELOIN", "ENTIA", "ETA", "INLET", "ION", "LATEN", "LEAN", "LEANT", "LENT", "LENTO", "LIE", "LIED", "LIEN", "LIANE", "LIENT", "LINEN", "LINE", "LINED", "LINING", "LINT", "LIT", "LITE", "LITEN", "LOAN", "LOANED", "LOANING", "NAIL", "NAILED", "NAILING", "NEAT", "NITE", "NOEL", "NOIL", "NOT", "NOTE", "NOTED", "NOTING", "OLEIN", "ONE", "TALON", "TAN", "TEA", "TEAL", "TEN", "TINE", "TOE", "TOIL", "TOILED", "TOILING", "TONE", "TON", "TONAL", "TONNE"
        ]
        
        dictionary = Set(basicWords)
        isLoaded = true
        let basicMessage = "⚠️ Loaded \(dictionary.count) basic words for offline use\n"
        writeToLog(basicMessage)
    }
    
    private func writeToLog(_ message: String) {
        // Write to Documents directory which we can access
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let logFile = documentsPath.appendingPathComponent("dictionary_log.txt")
            do {
                if FileManager.default.fileExists(atPath: logFile.path) {
                    // Append to existing file
                    let fileHandle = try FileHandle(forWritingTo: logFile)
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(message.data(using: .utf8)!)
                    fileHandle.closeFile()
                } else {
                    // Create new file
                    try message.write(to: logFile, atomically: true, encoding: .utf8)
                }
            } catch {
                // Ignore write errors
            }
        }
    }
    
    func isValidWord(_ word: String) -> Bool {
        return dictionary.contains(word.uppercased())
    }
    
    func generateSpellingBeeWords(letters: [String], centerLetter: String) -> [String] {
        let letterSet = Set(letters.map { $0.uppercased() })
        var validWords: [String] = []
        
        print("🔍 Generating words for letters: \(letters), center: \(centerLetter)")
        print("📚 Using dictionary with \(dictionary.count) words")
        print("🔤 Letter set: \(letterSet)")
        
        for word in dictionary {
            let wordUpper = word.uppercased()
            
            // Check if word uses only the given letters
            let wordLetters = Set(wordUpper.map { String($0) })
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
        
        print("✅ Generated \(validWords.count) valid words")
        if validWords.count > 0 {
            print("📝 Sample valid words: \(Array(validWords.prefix(10)))")
        }
        return validWords.sorted()
    }
    
    func getDictionaryInfo() -> String {
        return "Dictionary contains \(dictionary.count) words"
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