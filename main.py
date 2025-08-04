from flask import Flask, jsonify, request
from datetime import date
import requests

app = Flask(__name__)

# Example backup source — replace or enhance as needed
FREEBEE_URL = "https://www.sbsolver.com/api/today"  # community-maintained, sometimes rate-limited

def fetch_puzzle_data():
    try:
        res = requests.get(FREEBEE_URL)
        data = res.json()

        center_letter = data['centerLetter']
        outer_letters = data['outerLetters']
        all_letters = [center_letter] + outer_letters
        word_list = data['answers']

        return {
            "date": str(date.today()),
            "center_letter": center_letter,
            "letters": all_letters,
            "words": word_list,
        }
    except Exception as e:
        return {"error": str(e)}

def compute_stats(words, letters):
    pangrams = [w for w in words if all(l in w for l in letters)]
    compounds = [w for w in words if "-" in w or any(x in w for x in ["ing", "ness", "less", "ment"])]
    
    letter_table = {}
    for l in letters:
        letter_table[l] = sum(1 for w in words if w.startswith(l))

    prefix_tally = {}
    for w in words:
        prefix = w[:2]
        if prefix not in prefix_tally:
            prefix_tally[prefix] = 0
        prefix_tally[prefix] += 1

    return {
        "total_words": len(words),
        "pangram_count": len(pangrams),
        "compound_count": len(compounds),
        "word_count_by_letter": letter_table,
        "prefix_tally_2": prefix_tally,
    }

@app.route("/api/spelling-bee/today")
def get_today_puzzle():
    puzzle = fetch_puzzle_data()
    if "error" in puzzle:
        return jsonify(puzzle), 500

    stats = compute_stats(puzzle["words"], puzzle["letters"])
    return jsonify({
        "date": puzzle["date"],
        "center_letter": puzzle["center_letter"],
        "letters": puzzle["letters"],
        "words": puzzle["words"],
        "stats": stats
    })

@app.route("/")
def hello():
    return "Spelling Bee API is running."

if __name__ == "__main__":
    app.run(debug=True) 