#!/bin/bash

echo "🚀 Deploying Bee Helper API to Railway..."

# Install Railway CLI if not installed
if ! command -v railway &> /dev/null; then
    echo "Installing Railway CLI..."
    npm install -g @railway/cli
fi

# Login to Railway (if not already logged in)
echo "Logging into Railway..."
railway login

# Deploy the project
echo "Deploying to Railway..."
railway up

echo "✅ Deployment complete!"
echo "Your API will be available at: https://your-app-name.railway.app"
echo "Update your iOS app with the new URL!" 