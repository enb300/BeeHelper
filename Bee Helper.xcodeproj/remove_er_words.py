import os

def remove_er_words():
    """Remove all words that contain both 'E' and 'R' from the beehelper wordbase"""
    
    # File paths
    input_file = "beehelper_wordbase-41017.txt"
    output_file = "beehelper_wordbase_no_er.txt"
    
    if not os.path.exists(input_file):
        print(f"Error: {input_file} not found")
        return []
    
    try:
        print(f"Reading words from {input_file}...")
        with open(input_file, 'r') as f:
            words = [line.strip().lower() for line in f if line.strip()]
        
        print(f"Loaded {len(words)} words from {input_file}")
        
        # Filter out words containing both 'E' and 'R'
        filtered_words = []
        removed_words = []
        
        for word in words:
            if 'e' in word and 'r' in word:
                removed_words.append(word)
            else:
                filtered_words.append(word)
        
        print(f"Removed {len(removed_words)} words containing both 'E' and 'R'")
        print(f"Kept {len(filtered_words)} words")
        
        # Save filtered words to new file
        print(f"Writing to {output_file}...")
        with open(output_file, 'w') as f:
            for word in filtered_words:
                f.write(word + '\n')
        
        print(f"Successfully created {output_file} with {len(filtered_words)} words")
        
        # Show statistics
        print("\nStatistics:")
        print(f"  Original words: {len(words)}")
        print(f"  Words removed (containing E+R): {len(removed_words)}")
        print(f"  Words remaining: {len(filtered_words)}")
        print(f"  Reduction: {len(removed_words)/len(words)*100:.1f}%")
        
        # Show some examples of removed words
        print(f"\nSample removed words (first 20):")
        for word in removed_words[:20]:
            print(f"  {word}")
        if len(removed_words) > 20:
            print(f"  ... and {len(removed_words) - 20} more")
            
        # Show some examples of remaining words
        print(f"\nSample remaining words (first 20):")
        for word in filtered_words[:20]:
            print(f"  {word}")
            
        # Check for any words that might not meet the original criteria
        invalid_words = []
        for word in filtered_words:
            if len(word) < 4 or len(set(word)) > 7:
                invalid_words.append(word)
        
        if invalid_words:
            print(f"\nWarning: Found {len(invalid_words)} words that don't meet the 4+ letters and ≤7 unique letters criteria:")
            for word in invalid_words[:10]:
                print(f"  {word} ({len(word)} letters, {len(set(word))} unique letters)")
            if len(invalid_words) > 10:
                print(f"  ... and {len(invalid_words) - 10} more")
        else:
            print(f"\nAll remaining words still meet the original criteria (4+ letters, ≤7 unique letters)")
        
        return filtered_words
        
    except Exception as e:
        print(f"Error processing words: {e}")
        return []

if __name__ == "__main__":
    filtered_words = remove_er_words()
