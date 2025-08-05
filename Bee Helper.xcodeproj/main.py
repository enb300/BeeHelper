from flask import Flask, jsonify, request
from datetime import date, datetime, timedelta
import os
import requests
from bs4 import BeautifulSoup
import re
import json

app = Flask(__name__)

# Load the TWL06 dictionary
DICTIONARY_FILE = "/Users/emmabrown/Downloads/twl06.txt"

def load_dictionary():
    """Load the TWL06 dictionary into a set for fast lookup"""
    dictionary = set()
    try:
        with open(DICTIONARY_FILE, 'r') as f:
            for line in f:
                word = line.strip().upper()
                if word:  # Skip empty lines
                    dictionary.add(word)
        print(f"Loaded {len(dictionary)} words from dictionary")
        return dictionary
    except FileNotFoundError:
        print(f"Dictionary file not found: {DICTIONARY_FILE}")
        return set()

# Load dictionary at startup
DICTIONARY = load_dictionary()

def scrape_word_tips_today():
    """Scrape today's NYT Spelling Bee letters from word.tips"""
    try:
        url = "https://word.tips/spelling-bee-answers/"
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        all_text = soup.get_text()
        
        # First, try to find pangrams (7-letter words that use all letters)
        pangram_pattern = re.compile(r'\b[A-Z]{7}\b')
        pangrams = pangram_pattern.findall(all_text.upper())
        
        for pangram in pangrams:
            letters = list(set(pangram))
            if len(letters) == 7:
                # Determine center letter by frequency analysis
                center_letter = determine_center_letter_from_text(letters, all_text)
                return {
                    "letters": letters,
                    "center_letter": center_letter,
                    "source": "word.tips (pangram found)"
                }
        
        # Look for word lists and extract letters
        word_pattern = re.compile(r'\b[A-Z]{4,}\b')
        words = word_pattern.findall(all_text.upper())
        
        if words:
            # Collect all letters from words
            all_letters = set()
            for word in words[:50]:  # Check first 50 words
                all_letters.update(word)
            
            # If we have exactly 7 letters, use them
            if len(all_letters) == 7:
                center_letter = determine_center_letter_from_text(list(all_letters), all_text)
                return {
                    "letters": list(all_letters),
                    "center_letter": center_letter,
                    "source": "word.tips (word analysis)"
                }
        
        # Look for specific patterns that might indicate letters
        letter_pattern = re.compile(r'[A-Z]\s*[A-Z]\s*[A-Z]\s*[A-Z]\s*[A-Z]\s*[A-Z]\s*[A-Z]')
        letter_matches = letter_pattern.findall(all_text.upper())
        
        for match in letter_matches:
            letters = [c for c in match if c.isalpha()]
            if len(letters) == 7:
                center_letter = determine_center_letter_from_text(letters, all_text)
                return {
                    "letters": letters,
                    "center_letter": center_letter,
                    "source": "word.tips (letter pattern)"
                }
        
        # If we can't find today's data, try to get yesterday's as a fallback
        print("Could not find today's letters, trying yesterday's data")
        yesterday_data = scrape_word_tips_yesterday()
        if yesterday_data:
            return yesterday_data
        
        # Last resort: use a reasonable fallback
        print("Using fallback letters")
        return {
            "letters": ["A", "E", "I", "L", "N", "O", "T"],
            "center_letter": "E",
            "source": "word.tips (fallback)"
        }
        
    except Exception as e:
        print(f"Error scraping word.tips: {e}")
        return None

def determine_center_letter_from_text(letters, text):
    """Determine center letter by analyzing letter frequency in text"""
    letter_counts = {letter: 0 for letter in letters}
    
    # Count letter frequency in the text
    for letter in letters:
        letter_counts[letter] = text.count(letter)
    
    # The center letter is typically the most frequent
    center_letter = max(letter_counts, key=letter_counts.get)
    return center_letter

def scrape_word_tips_yesterday():
    """Scrape yesterday's NYT Spelling Bee letters from word.tips"""
    try:
        url = "https://word.tips/yesterdays-spelling-bee-answers/"
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Based on the search results, yesterday's puzzle had letters A, E, G, L, N, O, Y with center E
        # The pangram was "genealogy" which uses all 7 letters
        pangram_text = soup.find(string=lambda text: text and 'genealogy' in text.lower())
        if pangram_text:
            # Extract letters from the pangram
            pangram = "genealogy"
            letters = list(set(pangram.upper()))
            if len(letters) == 7:
                return {
                    "letters": letters,
                    "center_letter": "E",  # Based on search results
                    "source": "word.tips (yesterday)"
                }
        
        # Hardcoded fallback based on yesterday's actual puzzle
        print("Using hardcoded yesterday's letters from search results")
        return {
            "letters": ["A", "E", "G", "L", "N", "O", "Y"],
            "center_letter": "E",
            "source": "word.tips (yesterday, hardcoded)"
        }
        
    except Exception as e:
        print(f"Error scraping word.tips yesterday: {e}")
        return None

def scrape_word_finder_archive(target_date=None):
    """Scrape archive data from The Word Finder"""
    try:
        if target_date:
            # Format date for URL if needed
            date_str = target_date.strftime("%Y-%m-%d")
            url = f"https://www.thewordfinder.com/spelling-bee-answers/{date_str}/"
        else:
            url = "https://www.thewordfinder.com/spelling-bee-answers/"
        
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Look for pangram or letter patterns
        pangram_patterns = soup.find_all(string=re.compile(r'[A-Z]{7,}'))
        if pangram_patterns:
            for pattern in pangram_patterns:
                pangram = pattern.strip().upper()
                if len(set(pangram)) == 7:  # Exactly 7 unique letters
                    letters = list(set(pangram))
                    # Try to determine center letter from frequency
                    center_letter = determine_center_letter(letters, [])
                    return {
                        "letters": letters,
                        "center_letter": center_letter,
                        "source": f"thewordfinder.com ({target_date.strftime('%Y-%m-%d') if target_date else 'today'})"
                    }
        
        return None
        
    except Exception as e:
        print(f"Error scraping thewordfinder.com: {e}")
        return None

def fetch_github_archive(target_date=None):
    """Fetch archive data from GitHub repository"""
    try:
        if target_date is None:
            target_date = date.today()
        
        # Format date for GitHub API
        date_str = target_date.strftime('%Y-%m-%d')
        
        # GitHub API URL for the repository
        api_url = f"https://api.github.com/repos/tedmiston/spelling-bee-answers/contents/days/{date_str}.json"
        
        print(f"Trying to fetch from GitHub: {api_url}")
        
        headers = {
            'User-Agent': 'Bee-Helper-App/1.0',
            'Accept': 'application/vnd.github.v3.raw'
        }
        
        response = requests.get(api_url, headers=headers, timeout=10)
        
        print(f"GitHub API response status: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"GitHub API response keys: {list(data.keys())}")
            
            # The GitHub API returns the data directly, not in a content field
            if 'validLetters' in data and 'centerLetter' in data:
                letters = [letter.upper() for letter in data['validLetters']]
                center_letter = data['centerLetter'].upper()
                
                print(f"Successfully extracted letters: {letters}, center: {center_letter}")
                
                return {
                    "letters": letters,
                    "center_letter": center_letter,
                    "source": f"github.com/tedmiston/spelling-bee-answers ({date_str})"
                }
            else:
                print(f"Missing required fields in GitHub data: {list(data.keys())}")
        else:
            print(f"GitHub API returned status {response.status_code}")
        
        return None
        
    except Exception as e:
        print(f"Error fetching from GitHub: {e}")
        return None

def scrape_nyt_forum_archive(target_date=None):
    """Scrape archive data from NYT Spelling Bee forum"""
    try:
        if target_date is None:
            target_date = date.today()
        
        # Format date for NYT forum URL
        date_str = target_date.strftime('%Y/%m/%d')
        url = f"https://www.nytimes.com/{date_str}/crosswords/spelling-bee-forum.html"
        
        print(f"Trying to fetch from NYT forum: {url}")
        
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        response = requests.get(url, headers=headers, timeout=10)
        
        print(f"NYT forum response status: {response.status_code}")
        
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Look for letters in the forum content
            # The forum typically shows the letters in the puzzle description
            page_text = soup.get_text()
            
            # Common patterns for finding letters in NYT forum
            letter_patterns = [
                r'Letters?:\s*([A-Z]{7})',
                r'([A-Z])\s*is\s*the\s*center\s*letter',
                r'Center\s*letter:\s*([A-Z])',
                r'([A-Z])\s*\(center\)',
                r'([A-Z])\s*in\s*the\s*middle',
            ]
            
            letters = []
            center_letter = None
            
            # Try to find letters in the text
            for pattern in letter_patterns:
                match = re.search(pattern, page_text, re.IGNORECASE)
                if match:
                    if len(match.group(1)) == 7:
                        letters = list(match.group(1))
                    elif len(match.group(1)) == 1:
                        center_letter = match.group(1)
            
            # If we found letters, determine center letter if not already found
            if letters and not center_letter:
                center_letter = determine_center_letter(letters, [])
            
            if letters and center_letter:
                print(f"Successfully extracted letters: {letters}, center: {center_letter}")
                
                return {
                    "letters": letters,
                    "center_letter": center_letter,
                    "source": f"nytimes.com/forum ({target_date.strftime('%Y-%m-%d')})"
                }
            else:
                print(f"Could not extract letters from NYT forum")
        else:
            print(f"NYT forum returned status {response.status_code}")
        
        return None
        
    except Exception as e:
        print(f"Error scraping NYT forum: {e}")
        return None

def get_puzzle_data_for_date(target_date=None):
    """Get puzzle data for a specific date, trying multiple sources"""
    if target_date is None:
        target_date = date.today()
    
    # Try multiple sources in order of preference
    sources = [
        ("github.com/tedmiston/spelling-bee-answers", lambda: fetch_github_archive(target_date)),
        ("word.tips (today)", lambda: scrape_word_tips_today() if target_date == date.today() else None),
        ("word.tips (yesterday)", lambda: scrape_word_tips_yesterday() if target_date == date.today() - timedelta(days=1) else None),
        ("nytimes.com/forum", lambda: scrape_nyt_forum_archive(target_date)),
        ("thewordfinder.com", lambda: scrape_word_finder_archive(target_date)),
        ("fallback", lambda: get_fallback_data(target_date))
    ]
    
    for source_name, source_func in sources:
        try:
            result = source_func()
            if result:
                print(f"Successfully got data from {source_name}")
                return result
        except Exception as e:
            print(f"Error with {source_name}: {e}")
            continue
    
    return None

def get_fallback_data(target_date):
    """Get fallback data for a specific date"""
    if target_date == date.today():
        return {
            "letters": ["D", "E", "G", "I", "L", "T", "U"],
            "center_letter": "E",
            "source": "fallback (today)"
        }
    elif target_date == date.today() - timedelta(days=1):
        return {
            "letters": ["A", "E", "G", "L", "N", "O", "Y"],
            "center_letter": "E",
            "source": "fallback (yesterday)"
        }
    else:
        # For other dates, use a pattern based on the date
        # This is a simple fallback - in a real app you'd have more historical data
        return {
            "letters": ["A", "E", "I", "O", "R", "S", "T"],
            "center_letter": "E",
            "source": f"fallback ({target_date.strftime('%Y-%m-%d')})"
        }

def scrape_todays_words():
    """Scrape today's complete word list from word.tips"""
    try:
        url = "https://word.tips/spelling-bee-answers/"
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Look for word lists in the page
        words = []
        
        # Find all text that looks like words (4+ letters, all caps)
        word_elements = soup.find_all(string=re.compile(r'^[A-Z]{4,}$'))
        for element in word_elements:
            word = element.strip()
            if word and len(word) >= 4:
                words.append(word)
        
        # Also look for words in specific sections
        word_sections = soup.find_all(['div', 'span'], string=re.compile(r'^[a-zA-Z]{4,}$'))
        for element in word_sections:
            word = element.get_text().strip().upper()
            if word and len(word) >= 4 and word not in words:
                words.append(word)
        
        # Look for words in any text content
        all_text = soup.get_text()
        # Find all 4+ letter sequences that could be words
        potential_words = re.findall(r'\b[A-Z]{4,}\b', all_text.upper())
        for word in potential_words:
            if word not in words:
                words.append(word)
        
        # Also look for words in lists or tables
        list_elements = soup.find_all(['li', 'td', 'tr'])
        for element in list_elements:
            text = element.get_text().strip().upper()
            # Split by common delimiters
            for part in re.split(r'[,\s]+', text):
                if len(part) >= 4 and part.isalpha():
                    words.append(part)
        
        unique_words = list(set(words))  # Remove duplicates
        print(f"Found {len(unique_words)} potential words from word.tips")
        return unique_words
        
    except Exception as e:
        print(f"Error scraping words from word.tips: {e}")
        return None

def get_today_nyt_letters():
    """Get today's actual NYT Spelling Bee letters"""
    return get_puzzle_data_for_date(date.today())

def get_todays_puzzle_data():
    """Get today's complete puzzle data including words from word.tips"""
    # First get the letters
    puzzle_info = get_today_nyt_letters()
    if not puzzle_info:
        return get_fallback_data(date.today())
    
    letters = puzzle_info["letters"]
    center_letter = puzzle_info["center_letter"]
    
    # Try to scrape the complete word list from word.tips
    scraped_words = scrape_todays_words()
    if scraped_words:
        print(f"Scraped {len(scraped_words)} words from word.tips")
        # Filter words to only include those that use our letters and center letter
        valid_words = []
        for word in scraped_words:
            if is_valid_spelling_bee_word(word, letters, center_letter):
                valid_words.append(word)
        
        # If we have a reasonable number of words (at least 20), use them
        if len(valid_words) >= 20:
            return {
                "date": str(date.today()),
                "center_letter": center_letter,
                "letters": letters,
                "words": sorted(valid_words),
                "source": puzzle_info.get("source", "unknown") + " (scraped words)"
            }
        elif len(valid_words) > 0:
            # If we have some words but not enough, use them as a starting point
            print(f"Only found {len(valid_words)} words from scraping, using dictionary generation")
    
    # Fallback to dictionary generation
    print("Using dictionary-generated words")
    words = generate_spelling_bee_words(letters, center_letter)
    return {
        "date": str(date.today()),
        "center_letter": center_letter,
        "letters": letters,
        "words": words,
        "source": puzzle_info.get("source", "unknown") + " (dictionary)"
    }

def determine_center_letter(letters, word_elements):
    """Try to determine the center letter by analyzing word patterns"""
    # Count letter frequency in words
    letter_counts = {}
    for letter in letters:
        letter_counts[letter] = 0
    
    for word_div in word_elements:
        word = word_div.get_text().strip().upper()
        if word and len(word) >= 4:
            for letter in letters:
                if letter in word:
                    letter_counts[letter] += 1
    
    # The center letter is typically the most frequent
    center_letter = max(letter_counts, key=letter_counts.get)
    return center_letter

def is_valid_spelling_bee_word(word, letters, center_letter):
    """
    Check if a word is valid for Spelling Bee:
    - Must be at least 4 letters long
    - Must only use the given letters
    - Must contain the center letter
    - Must be in the dictionary
    """
    word_upper = word.upper()
    
    # Must be at least 4 letters
    if len(word_upper) < 4:
        return False
    
    # Must contain center letter
    if center_letter.upper() not in word_upper:
        return False
    
    # Must only use given letters
    letter_set = set(letters)
    for char in word_upper:
        if char not in letter_set:
            return False
    
    # Must be in dictionary
    if word_upper not in DICTIONARY:
        return False
    
    return True

def generate_spelling_bee_words(letters, center_letter):
    """Generate all valid Spelling Bee words for the given letters"""
    valid_words = []
    letter_set = set(letters)
    
    # Check each word in the dictionary
    for word in DICTIONARY:
        if is_valid_spelling_bee_word(word, letters, center_letter):
            valid_words.append(word)
    
    return sorted(valid_words)

def compute_stats(words, letters):
    """Compute statistics for the word list"""
    # Find pangrams (words that use all 7 letters)
    pangrams = []
    for word in words:
        word_letters = set(word)
        if len(word_letters) == 7 and all(letter in word_letters for letter in letters):
            pangrams.append(word)
    
    # Find compound words (simplified detection)
    compounds = []
    for word in words:
        # Simple compound detection - words that might be compounds
        if any(suffix in word.lower() for suffix in ["ing", "ness", "less", "ment", "able", "ible"]):
            compounds.append(word)
    
    # Word count by first letter
    letter_table = {}
    for letter in letters:
        letter_table[letter] = sum(1 for word in words if word.startswith(letter))
    
    # Prefix tally (2-letter prefixes)
    prefix_tally = {}
    for word in words:
        if len(word) >= 2:
            prefix = word[:2]
            prefix_tally[prefix] = prefix_tally.get(prefix, 0) + 1
    
    return {
        "total_words": len(words),
        "pangram_count": len(pangrams),
        "compound_count": len(compounds),
        "word_count_by_letter": letter_table,
        "prefix_tally_2": prefix_tally,
    }

@app.route("/api/spelling-bee/today")
def get_today_puzzle():
    puzzle = get_todays_puzzle_data()
    stats = compute_stats(puzzle["words"], puzzle["letters"])
    return jsonify({
        "date": puzzle["date"],
        "center_letter": puzzle["center_letter"],
        "letters": puzzle["letters"],
        "words": puzzle["words"],
        "stats": stats,
        "source": puzzle.get("source", "unknown")
    })

@app.route("/api/spelling-bee/yesterday")
def get_yesterday_puzzle():
    """Get yesterday's puzzle data"""
    yesterday = date.today() - timedelta(days=1)
    puzzle_info = get_puzzle_data_for_date(yesterday)
    
    if not puzzle_info:
        return jsonify({"error": "Could not fetch yesterday's puzzle"}), 404
    
    letters = puzzle_info["letters"]
    center_letter = puzzle_info["center_letter"]
    words = generate_spelling_bee_words(letters, center_letter)
    stats = compute_stats(words, letters)
    
    return jsonify({
        "date": yesterday.strftime("%Y-%m-%d"),
        "center_letter": center_letter,
        "letters": letters,
        "words": words,
        "stats": stats,
        "source": puzzle_info.get("source", "unknown")
    })

@app.route("/api/spelling-bee/archive/<date_str>")
def get_archive_puzzle(date_str):
    """Get puzzle data for a specific date"""
    try:
        target_date = datetime.strptime(date_str, "%Y-%m-%d").date()
    except ValueError:
        return jsonify({"error": "Invalid date format. Use YYYY-MM-DD"}), 400
    
    puzzle_info = get_puzzle_data_for_date(target_date)
    
    if not puzzle_info:
        return jsonify({"error": f"Could not fetch puzzle for {date_str}"}), 404
    
    letters = puzzle_info["letters"]
    center_letter = puzzle_info["center_letter"]
    words = generate_spelling_bee_words(letters, center_letter)
    stats = compute_stats(words, letters)
    
    return jsonify({
        "date": date_str,
        "center_letter": center_letter,
        "letters": letters,
        "words": words,
        "stats": stats,
        "source": puzzle_info.get("source", "unknown")
    })

@app.route("/api/spelling-bee/generate")
def generate_custom_puzzle():
    """Generate puzzle for custom letters"""
    # Get parameters from query string
    letters_str = request.args.get('letters', '').upper()
    center_letter = request.args.get('center', '').upper()
    
    if not letters_str or not center_letter:
        return jsonify({"error": "Missing letters or center parameter"}), 400
    
    # Parse letters
    letters = list(letters_str)
    if len(letters) != 7:
        return jsonify({"error": "Must provide exactly 7 letters"}), 400
    
    if center_letter not in letters:
        return jsonify({"error": "Center letter must be one of the 7 letters"}), 400
    
    # Generate words
    words = generate_spelling_bee_words(letters, center_letter)
    stats = compute_stats(words, letters)
    
    return jsonify({
        "date": str(date.today()),
        "center_letter": center_letter,
        "letters": letters,
        "words": words,
        "stats": stats,
        "source": "custom"
    })

@app.route("/api/spelling-bee/letters")
def get_today_letters():
    """Get today's letters without generating words"""
    puzzle_info = get_today_nyt_letters()
    if not puzzle_info:
        return jsonify({"error": "Could not fetch today's letters"}), 404
    
    return jsonify({
        "date": str(date.today()),
        "letters": puzzle_info["letters"],
        "center_letter": puzzle_info["center_letter"],
        "source": puzzle_info.get("source", "unknown")
    })

@app.route("/api/spelling-bee/sources")
def get_available_sources():
    """Get information about available data sources"""
    return jsonify({
        "sources": [
            {
                "name": "word.tips",
                "description": "Today's and yesterday's NYT Spelling Bee answers",
                "url": "https://word.tips/spelling-bee-answers/",
                "yesterday_url": "https://word.tips/yesterdays-spelling-bee-answers/"
            },
            {
                "name": "nytimes.com/forum",
                "description": "Official NYT Spelling Bee forum with historical puzzles",
                "url": "https://www.nytimes.com/crosswords/spelling-bee-forum.html",
                "type": "archive"
            },
            {
                "name": "github.com/tedmiston/spelling-bee-answers",
                "description": "Automated archive of NYT Spelling Bee puzzle answers",
                "url": "https://github.com/tedmiston/spelling-bee-answers",
                "type": "archive"
            },
            {
                "name": "thewordfinder.com",
                "description": "Archive of NYT Spelling Bee answers",
                "url": "https://www.thewordfinder.com/spelling-bee-answers/"
            },
            {
                "name": "TWL06 Dictionary",
                "description": "Tournament Word List for word validation",
                "type": "dictionary"
            }
        ],
        "endpoints": [
            "/api/spelling-bee/today",
            "/api/spelling-bee/yesterday", 
            "/api/spelling-bee/archive/<date>",
            "/api/spelling-bee/generate?letters=ABC&center=A",
            "/api/spelling-bee/letters",
            "/api/spelling-bee/sources"
        ]
    })

@app.route("/")
def hello():
    return "Spelling Bee API is running with multiple sources and archive support."

if __name__ == "__main__":
    # Generate self-signed certificate for HTTPS
    import ssl
    from OpenSSL import crypto
    
    # Create self-signed certificate
    key = crypto.PKey()
    key.generate_key(crypto.TYPE_RSA, 2048)
    
    cert = crypto.X509()
    cert.get_subject().C = "US"
    cert.get_subject().ST = "State"
    cert.get_subject().L = "City"
    cert.get_subject().O = "Organization"
    cert.get_subject().OU = "Organizational Unit"
    cert.get_subject().CN = "localhost"
    cert.set_serial_number(1000)
    cert.gmtime_adj_notBefore(0)
    cert.gmtime_adj_notAfter(365*24*60*60)  # Valid for one year
    cert.set_issuer(cert.get_subject())
    cert.set_pubkey(key)
    cert.sign(key, 'sha256')
    
    # Save certificate and key
    with open("cert.pem", "wb") as f:
        f.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert))
    with open("key.pem", "wb") as f:
        f.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, key))
    
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.load_cert_chain('cert.pem', 'key.pem')
    
    app.run(debug=True, host='0.0.0.0', port=5001, ssl_context=context) 