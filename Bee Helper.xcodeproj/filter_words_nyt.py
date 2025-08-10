import os

def filter_words():
    """Filter words from the NYT Spelling Bee cleaned file based on length and unique letter requirements"""
    
    # File path for the NYT Spelling Bee cleaned file
    input_file = "/Users/emmabrown/Downloads/nyt_spellingbee_cleaned_tight.txt"
    
    if not os.path.exists(input_file):
        print(f"Error: {input_file} not found")
        return []
    
    try:
        print(f"Reading words from {input_file}...")
        with open(input_file, 'r') as f:
            words = [line.strip().lower() for line in f if line.strip()]
        
        print(f"Loaded {len(words)} words from NYT Spelling Bee file")
        
        # Filter words
        filtered_words = []
        for word in words:
            # Skip words under 4 letters
            if len(word) < 4:
                continue
                
            # Count unique letters
            unique_letters = len(set(word))
            
            # Skip words with more than 7 unique letters
            if unique_letters > 7:
                continue
                
            filtered_words.append(word)
        
        print(f"Filtered to {len(filtered_words)} words")
        
        # Save filtered words to file
        output_file = "filtered_nyt_words_4to7letters.txt"
        with open(output_file, 'w') as f:
            for word in filtered_words:
                f.write(word + '\n')
        
        print(f"Saved filtered words to {output_file}")
        
        # Show some statistics
        length_distribution = {}
        unique_letter_distribution = {}
        
        for word in filtered_words:
            length = len(word)
            unique_letters = len(set(word))
            
            length_distribution[length] = length_distribution.get(length, 0) + 1
            unique_letter_distribution[unique_letters] = unique_letter_distribution.get(unique_letters, 0) + 1
        
        print("\nLength distribution:")
        for length in sorted(length_distribution.keys()):
            print(f"  {length} letters: {length_distribution[length]} words")
            
        print("\nUnique letter distribution:")
        for unique_letters in sorted(unique_letter_distribution.keys()):
            print(f"  {unique_letter_distribution[unique_letters]} words with {unique_letters} unique letters")
            
        # Show some examples
        print(f"\nSample words (first 20):")
        for word in filtered_words[:20]:
            print(f"  {word} ({len(word)} letters, {len(set(word))} unique letters)")
            
        return filtered_words
        
    except Exception as e:
        print(f"Error processing words: {e}")
        return []

if __name__ == "__main__":
    filtered_words = filter_words()
