# Bee Helper API Backend

This is a Python Flask API that fetches NYT Spelling Bee puzzle data and serves it to your iOS app.

## Setup Instructions

### 1. Install Python Dependencies
```bash
pip install -r requirements.txt
```

### 2. Run the API Server
```bash
python main.py
```

The API will start on `http://localhost:5000`

### 3. Test the API
Visit `http://localhost:5000/api/spelling-bee/today` in your browser to see the JSON response.

### 4. iOS App Integration
The iOS app is already configured to fetch from `http://localhost:5000/api/spelling-bee/today`

## API Endpoints

- `GET /api/spelling-bee/today` - Returns today's puzzle data
- `GET /` - Health check endpoint

## Response Format

```json
{
  "date": "2025-08-03",
  "center_letter": "E",
  "letters": ["A", "E", "G", "L", "N", "O", "Y"],
  "words": ["AEON", "AGELONG", "ALGAE", ...],
  "stats": {
    "total_words": 53,
    "pangram_count": 1,
    "compound_count": 3,
    "word_count_by_letter": {"A": 12, "E": 8, ...},
    "prefix_tally_2": {"AE": 1, "AG": 1, ...}
  }
}
```

## Troubleshooting

1. **API not responding**: Make sure the Flask server is running on port 5000
2. **Network errors**: Check that your iOS app can reach localhost:5000
3. **Data not updating**: The API fetches from SBSolver.com - if that's down, it will return an error

## Next Steps

- Deploy to a cloud service (Heroku, Railway, etc.) for production use
- Add caching to reduce API calls
- Implement archive endpoints for past puzzles
- Add authentication if needed 