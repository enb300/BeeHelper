#!/bin/bash

echo "🚀 Deploying Bee Helper API to Render..."

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit for Render deployment"
fi

echo "✅ Your app is ready for Render deployment!"
echo ""
echo "📋 Next steps:"
echo "1. Go to https://render.com"
echo "2. Sign up for a free account"
echo "3. Click 'New +' → 'Web Service'"
echo "4. Connect your GitHub repository"
echo "5. Set the following:"
echo "   - Name: bee-helper-api"
echo "   - Environment: Python"
echo "   - Build Command: pip install -r requirements.txt"
echo "   - Start Command: gunicorn main:app --bind 0.0.0.0:\$PORT"
echo "6. Click 'Create Web Service'"
echo ""
echo "🌐 Your app will be available at: https://your-app-name.onrender.com"
echo "📱 Update your iOS app with the new URL!" 