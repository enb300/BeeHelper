import os
import re

def remove_proper_nouns():
    """Remove city names, brand names, and other proper nouns from the beehelper wordbase"""
    
    # File paths
    input_file = "beehelper_wordbase_no_er.txt"
    output_file = "beehelper_wordbase_clean.txt"
    
    if not os.path.exists(input_file):
        print(f"Error: {input_file} not found")
        return []
    
    try:
        print(f"Reading words from {input_file}...")
        with open(input_file, 'r') as f:
            words = [line.strip().lower() for line in f if line.strip()]
        
        print(f"Loaded {len(words)} words from {input_file}")
        
        # Filter out proper nouns using multiple strategies
        filtered_words = []
        removed_words = []
        
        # Common proper noun indicators
        proper_noun_patterns = [
            # Capitalized words (though we're working with lowercase, keeping for reference)
            r'^[A-Z]',
            
            # Common city/country suffixes
            r'.*burg$',      # hamburg, pittsburgh
            r'.*town$',      # charlestown
            r'.*ville$',     # nashville
            r'.*ton$',       # boston, washington
            r'.*land$',      # england, ireland
            r'.*ia$',        # california, australia
            r'.*stan$',      # pakistan, afghanistan
            r'.*polis$',     # minneapolis, indianapolis
            r'.*dale$',      # rosedale
            r'.*field$',     # springfield
            r'.*port$',      # newport, portland
            r'.*ford$',      # oxford, waterford
            r'.*bridge$',    # cambridge
            r'.*wood$',      # hollywood
            r'.*hill$',      # nottingham
            r'.*shire$',     # yorkshire
            r'.*ham$',       # birmingham
            r'.*pool$',      # blackpool
            r'.*mouth$',     # plymouth
            r'.*chester$',   # manchester
            r'.*caster$',    # lancaster
            r'.*minster$',   # westminster
            r'.*wich$',      # norwich
            r'.*combe$',     # salcombe
            r'.*leigh$',     # burleigh
            r'.*don$',       # london
            r'.*don$',       # london
            r'.*ham$',       # birmingham
            r'.*pool$',      # blackpool
            r'.*mouth$',     # plymouth
            r'.*chester$',   # manchester
            r'.*caster$',    # lancaster
            r'.*minster$',   # westminster
            r'.*wich$',      # norwich
            r'.*combe$',     # salcombe
            r'.*leigh$',     # burleigh
            r'.*don$',       # london
        ]
        
        # Common brand names and companies
        brand_names = {
            'nike', 'adidas', 'puma', 'reebok', 'under', 'armour', 'levis', 'gap', 'old', 'navy',
            'target', 'walmart', 'costco', 'kroger', 'safeway', 'whole', 'foods', 'trader', 'joes',
            'starbucks', 'dunkin', 'mcdonalds', 'burger', 'king', 'wendys', 'subway', 'dominos',
            'pizza', 'hut', 'kfc', 'taco', 'bell', 'chipotle', 'panera', 'bread', 'chick', 'fil',
            'apple', 'google', 'microsoft', 'amazon', 'facebook', 'twitter', 'instagram', 'netflix',
            'disney', 'warner', 'bros', 'sony', 'nintendo', 'xbox', 'playstation', 'steam',
            'coca', 'cola', 'pepsi', 'dr', 'pepper', 'sprite', 'fanta', 'mountain', 'dew',
            'ford', 'chevrolet', 'toyota', 'honda', 'nissan', 'bmw', 'mercedes', 'audi', 'volkswagen',
            'hilton', 'marriott', 'hyatt', 'holiday', 'inn', 'best', 'western', 'motel', 'six',
            'ibm', 'hp', 'dell', 'lenovo', 'asus', 'acer', 'samsung', 'lg', 'panasonic', 'sharp',
            'nike', 'adidas', 'puma', 'reebok', 'under', 'armour', 'levis', 'gap', 'old', 'navy',
            'target', 'walmart', 'costco', 'kroger', 'safeway', 'whole', 'foods', 'trader', 'joes',
            'starbucks', 'dunkin', 'mcdonalds', 'burger', 'king', 'wendys', 'subway', 'dominos',
            'pizza', 'hut', 'kfc', 'taco', 'bell', 'chipotle', 'panera', 'bread', 'chick', 'fil',
            'apple', 'google', 'microsoft', 'amazon', 'facebook', 'twitter', 'instagram', 'netflix',
            'disney', 'warner', 'bros', 'sony', 'nintendo', 'xbox', 'playstation', 'steam',
            'coca', 'cola', 'pepsi', 'dr', 'pepper', 'sprite', 'fanta', 'mountain', 'dew',
            'ford', 'chevrolet', 'toyota', 'honda', 'nissan', 'bmw', 'mercedes', 'audi', 'volkswagen',
            'hilton', 'marriott', 'hyatt', 'holiday', 'inn', 'best', 'western', 'motel', 'six',
            'ibm', 'hp', 'dell', 'lenovo', 'asus', 'acer', 'samsung', 'lg', 'panasonic', 'sharp'
        }
        
        # Common city names
        city_names = {
            'new', 'york', 'london', 'paris', 'tokyo', 'berlin', 'madrid', 'rome', 'moscow',
            'beijing', 'shanghai', 'mumbai', 'delhi', 'cairo', 'lagos', 'nairobi', 'johannesburg',
            'sydney', 'melbourne', 'brisbane', 'perth', 'auckland', 'wellington', 'vancouver',
            'toronto', 'montreal', 'calgary', 'edmonton', 'ottawa', 'winnipeg', 'halifax',
            'chicago', 'los', 'angeles', 'houston', 'phoenix', 'philadelphia', 'san', 'antonio',
            'san', 'diego', 'dallas', 'austin', 'jacksonville', 'fort', 'worth', 'columbus',
            'charlotte', 'san', 'francisco', 'indianapolis', 'seattle', 'denver', 'washington',
            'boston', 'el', 'paso', 'nashville', 'detroit', 'oklahoma', 'portland', 'las', 'vegas',
            'memphis', 'louisville', 'baltimore', 'milwaukee', 'albuquerque', 'tucson', 'fresno',
            'sacramento', 'atlanta', 'long', 'beach', 'colorado', 'springs', 'raleigh', 'miami',
            'cleveland', 'tampa', 'orlando', 'minneapolis', 'kansas', 'city', 'st', 'louis',
            'oakland', 'pittsburgh', 'cincinnati', 'st', 'paul', 'anchorage', 'honolulu',
            'buffalo', 'rochester', 'tulsa', 'fremont', 'bakersfield', 'durham', 'chula', 'vista',
            'irvine', 'boise', 'richmond', 'norfolk', 'spokane', 'baton', 'rouge', 'tacoma',
            'fort', 'wayne', 'arlington', 'hialeah', 'glendale', 'garland', 'modesto', 'laredo',
            'chandler', 'lubbock', 'madison', 'laredo', 'chandler', 'lubbock', 'madison'
        }
        
        # Common country names
        country_names = {
            'america', 'canada', 'mexico', 'brazil', 'argentina', 'chile', 'peru', 'colombia',
            'venezuela', 'ecuador', 'bolivia', 'paraguay', 'uruguay', 'guyana', 'suriname',
            'france', 'germany', 'italy', 'spain', 'portugal', 'netherlands', 'belgium', 'switzerland',
            'austria', 'poland', 'czech', 'republic', 'slovakia', 'hungary', 'romania', 'bulgaria',
            'greece', 'turkey', 'ukraine', 'russia', 'belarus', 'lithuania', 'latvia', 'estonia',
            'finland', 'sweden', 'norway', 'denmark', 'iceland', 'ireland', 'united', 'kingdom',
            'china', 'japan', 'korea', 'india', 'pakistan', 'bangladesh', 'sri', 'lanka', 'nepal',
            'thailand', 'vietnam', 'cambodia', 'laos', 'myanmar', 'malaysia', 'singapore', 'indonesia',
            'philippines', 'australia', 'new', 'zealand', 'fiji', 'papua', 'guinea', 'solomon',
            'south', 'africa', 'nigeria', 'kenya', 'uganda', 'tanzania', 'ethiopia', 'sudan',
            'egypt', 'morocco', 'algeria', 'tunisia', 'libya', 'chad', 'niger', 'mali', 'senegal'
        }
        
        # Common first names
        first_names = {
            'john', 'jane', 'mike', 'sarah', 'david', 'lisa', 'james', 'mary', 'robert', 'jennifer',
            'michael', 'linda', 'william', 'elizabeth', 'richard', 'barbara', 'thomas', 'susan',
            'christopher', 'jessica', 'charles', 'sarah', 'daniel', 'karen', 'matthew', 'nancy',
            'anthony', 'lisa', 'mark', 'betty', 'donald', 'helen', 'steven', 'sandra', 'paul',
            'donna', 'andrew', 'carol', 'joshua', 'ruth', 'kenneth', 'sharon', 'kevin', 'michelle',
            'brian', 'laura', 'george', 'emily', 'edward', 'kimberly', 'ronald', 'deborah', 'timothy',
            'dorothy', 'jason', 'lisa', 'jeffrey', 'nancy', 'ryan', 'karen', 'jacob', 'betty',
            'gary', 'helen', 'nicholas', 'sandra', 'eric', 'donna', 'jonathan', 'ruth', 'stephen',
            'julie', 'larry', 'joyce', 'justin', 'virginia', 'scott', 'victoria', 'brandon', 'kelly',
            'benjamin', 'lauren', 'samuel', 'christine', 'frank', 'amy', 'gregory', 'angela',
            'raymond', 'shirley', 'alexander', 'anna', 'patrick', 'brenda', 'jack', 'pamela',
            'dennis', 'emma', 'jerry', 'nicole', 'tyler', 'helen', 'aaron', 'samantha', 'jose',
            'katherine', 'adam', 'christine', 'nathan', 'debra', 'henry', 'rachel', 'douglas', 'carolyn'
        }
        
        # Common last names
        last_names = {
            'smith', 'johnson', 'williams', 'brown', 'jones', 'garcia', 'miller', 'davis',
            'rodriguez', 'martinez', 'hernandez', 'lopez', 'gonzalez', 'wilson', 'anderson',
            'thomas', 'taylor', 'moore', 'jackson', 'martin', 'lee', 'perez', 'thompson',
            'white', 'harris', 'sanchez', 'clark', 'ramirez', 'lewis', 'robinson', 'walker',
            'young', 'allen', 'king', 'wright', 'scott', 'torres', 'nguyen', 'hill', 'flores',
            'green', 'adams', 'nelson', 'baker', 'hall', 'rivera', 'campbell', 'mitchell',
            'carter', 'roberts', 'gomez', 'phillips', 'evans', 'turner', 'diaz', 'parker',
            'cruz', 'edwards', 'collins', 'reyes', 'stewart', 'morris', 'morales', 'murphy',
            'rogers', 'reed', 'cook', 'morgan', 'bell', 'murphy', 'bailey', 'rivera', 'cooper',
            'richardson', 'cox', 'howard', 'ward', 'torres', 'peterson', 'gray', 'ramirez',
            'james', 'watson', 'brooks', 'kelly', 'sanders', 'price', 'bennett', 'wood',
            'barnes', 'ross', 'henderson', 'coleman', 'jenkins', 'perry', 'powell', 'long',
            'patterson', 'hughes', 'flores', 'washington', 'butler', 'simmons', 'foster',
            'gonzales', 'bryant', 'alexander', 'russell', 'griffin', 'diaz', 'hayes'
        }
        
        # Combined set of proper nouns to remove
        proper_nouns = brand_names.union(city_names).union(country_names).union(first_names).union(last_names)
        
        print(f"Identified {len(proper_nouns)} common proper nouns to filter out")
        
        # Filter words
        for word in words:
            should_remove = False
            
            # Check if word is in our proper noun lists
            if word in proper_nouns:
                should_remove = True
            
            # Check if word matches common proper noun patterns
            for pattern in proper_noun_patterns:
                if re.match(pattern, word):
                    should_remove = True
                    break
            
            # Additional checks for proper nouns
            if len(word) >= 4:
                # Words that start with common proper noun indicators
                if word.startswith(('mc', 'mac', 'van', 'von', 'de', 'del', 'di', 'da', 'du', 'le', 'la')):
                    should_remove = True
                
                # Words that end with common proper noun indicators
                if word.endswith(('berg', 'stein', 'man', 'son', 'sen', 'ski', 'sky', 'witz', 'berg')):
                    should_remove = True
            
            if should_remove:
                removed_words.append(word)
            else:
                filtered_words.append(word)
        
        print(f"Removed {len(removed_words)} proper nouns")
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
        print(f"  Words removed (proper nouns): {len(removed_words)}")
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
    filtered_words = remove_proper_nouns()
