from flask import Flask, jsonify, request
from datetime import date, datetime, timedelta
import os

app = Flask(__name__)

# Simple fallback data
FALLBACK_DATA = {
    "today": {
        "letters": ["A", "E", "I", "L", "N", "O", "T"],
        "center_letter": "E",
        "words": ["ALIEN", "ALINE", "ALOIN", "ANILE", "ANOLE", "ANTLE", "ELAIN", "ELOIN", "ENTIA", "INLET", "LATEN", "LEANT", "LENTO", "LIANE", "LIENT", "LINEN", "LITEN", "LOAN", "NAIL", "NEAT", "NITE", "NOEL", "NOIL", "OLEIN", "TALON", "TINE", "TOIL", "TONE"],
        "source": "fallback"
    },
    "yesterday": {
        "letters": ["A", "E", "G", "L", "N", "O", "Y"],
        "center_letter": "E", 
        "words": ["AGLEY", "ALONG", "ANGEL", "ANGLE", "ANNOY", "EAGLE", "GLEAN", "GLOBE", "GLOVE", "GOAL", "GONE", "GONG", "GOWN", "LEAN", "LOAN", "LONE", "LONG", "NOEL", "OGLE", "ONLY", "YANG", "YEAR", "YELL", "YOKE"],
        "source": "fallback"
    }
}

def compute_stats(words, letters):
    """Compute statistics for the puzzle"""
    pangrams = [word for word in words if len(set(word)) == 7]
    compounds = [word for word in words if len(word) > 8]
    
    # Create letter frequency table
    letter_table = {}
    for letter in letters:
        letter_table[letter] = len([word for word in words if letter in word])
    
    # Create prefix tally
    prefix_tally = {}
    for word in words:
        if len(word) >= 4:
            prefix = word[:2]
            prefix_tally[prefix] = prefix_tally.get(prefix, 0) + 1
    
    return {
        "total_words": len(words),
        "pangram_count": len(pangrams),
        "compound_count": len(compounds),
        "word_count_by_letter": letter_table,
        "prefix_tally_2": prefix_tally,
    }

@app.route("/")
def hello():
    return "Spelling Bee API is running."

@app.route("/test")
def test():
    return jsonify({"status": "ok", "message": "API is working"})

@app.route("/api/spelling-bee/today")
def get_today_puzzle():
    try:
        data = FALLBACK_DATA["today"]
        stats = compute_stats(data["words"], data["letters"])
        
        return jsonify({
            "date": str(date.today()),
            "center_letter": data["center_letter"],
            "letters": data["letters"],
            "words": data["words"],
            "stats": stats,
            "source": data["source"]
        })
    except Exception as e:
        print(f"Error in get_today_puzzle: {e}")
        return jsonify({"error": "Internal server error"}), 500

@app.route("/api/spelling-bee/yesterday")
def get_yesterday_puzzle():
    try:
        yesterday = date.today() - timedelta(days=1)
        data = FALLBACK_DATA["yesterday"]
        stats = compute_stats(data["words"], data["letters"])
        
        return jsonify({
            "date": yesterday.strftime("%Y-%m-%d"),
            "center_letter": data["center_letter"],
            "letters": data["letters"],
            "words": data["words"],
            "stats": stats,
            "source": data["source"]
        })
    except Exception as e:
        print(f"Error in get_yesterday_puzzle: {e}")
        return jsonify({"error": "Internal server error"}), 500

@app.route("/api/spelling-bee/archive/<date_str>")
def get_archive_puzzle(date_str):
    try:
        # For now, return yesterday's data for any archive request
        data = FALLBACK_DATA["yesterday"]
        stats = compute_stats(data["words"], data["letters"])
        
        return jsonify({
            "date": date_str,
            "center_letter": data["center_letter"],
            "letters": data["letters"],
            "words": data["words"],
            "stats": stats,
            "source": data["source"]
        })
    except Exception as e:
        print(f"Error in get_archive_puzzle: {e}")
        return jsonify({"error": "Internal server error"}), 500

if __name__ == "__main__":
    import os
    port = int(os.environ.get('PORT', 5001))
    app.run(debug=True, host='0.0.0.0', port=port) 