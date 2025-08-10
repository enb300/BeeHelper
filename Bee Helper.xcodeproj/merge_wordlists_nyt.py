import os

def merge_wordlists():
    """Merge cleaned_scraped_words.txt with filtered_nyt_words_4to7letters.txt, remove duplicates, and create beehelper_wordbase-[count].txt"""
    
    # File paths
    scraped_words_file = "cleaned_scraped_words.txt"
    filtered_words_file = "filtered_nyt_words_4to7letters.txt"
    
    # Check if files exist
    if not os.path.exists(scraped_words_file):
        print(f"Error: {scraped_words_file} not found")
        return
    
    if not os.path.exists(filtered_words_file):
        print(f"Error: {filtered_words_file} not found")
        return
    
    try:
        # Read cleaned_scraped_words.txt
        print(f"Reading {scraped_words_file}...")
        with open(scraped_words_file, 'r') as f:
            scraped_words = set(line.strip().lower() for line in f if line.strip())
        print(f"Loaded {len(scraped_words)} words from {scraped_words_file}")
        
        # Read filtered_nyt_words_4to7letters.txt
        print(f"Reading {filtered_words_file}...")
        with open(filtered_words_file, 'r') as f:
            filtered_words = set(line.strip().lower() for line in f if line.strip())
        print(f"Loaded {len(filtered_words)} words from {filtered_words_file}")
        
        # Merge word sets (automatically removes duplicates)
        merged_words = scraped_words.union(filtered_words)
        print(f"Merged to {len(merged_words)} unique words")
        
        # Convert to sorted list for consistent output
        sorted_words = sorted(merged_words)
        
        # Create filename with word count
        output_file = f"beehelper_wordbase-{len(sorted_words)}.txt"
        
        # Write to new file
        print(f"Writing to {output_file}...")
        with open(output_file, 'w') as f:
            for word in sorted_words:
                f.write(word + '\n')
        
        print(f"Successfully created {output_file} with {len(sorted_words)} words")
        
        # Show statistics
        print("\nStatistics:")
        print(f"  Words from {scraped_words_file}: {len(scraped_words)}")
        print(f"  Words from {filtered_words_file}: {len(filtered_words)}")
        print(f"  Duplicates removed: {len(scraped_words) + len(filtered_words) - len(merged_words)}")
        print(f"  Total unique words: {len(merged_words)}")
        
        # Show some examples
        print(f"\nSample words from merged list (first 20):")
        for word in sorted_words[:20]:
            print(f"  {word}")
            
        # Check for any words that might not meet the criteria
        invalid_words = []
        for word in sorted_words:
            if len(word) < 4 or len(set(word)) > 7:
                invalid_words.append(word)
        
        if invalid_words:
            print(f"\nWarning: Found {len(invalid_words)} words that don't meet the 4+ letters and ≤7 unique letters criteria:")
            for word in invalid_words[:10]:  # Show first 10
                print(f"  {word} ({len(word)} letters, {len(set(word))} unique letters)")
            if len(invalid_words) > 10:
                print(f"  ... and {len(invalid_words) - 10} more")
        else:
            print(f"\nAll words meet the criteria (4+ letters, ≤7 unique letters)")
        
        return sorted_words
        
    except Exception as e:
        print(f"Error processing word lists: {e}")
        return []

if __name__ == "__main__":
    merged_words = merge_wordlists()
