#!/bin/bash

# run this first: chmod +x githelper.sh
# run this script: ./githelper.sh

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed. Please install it first: https://cli.github.com/"
    exit 1
fi

# Authenticate with GitHub CLI
echo "🔐 Checking GitHub authentication..."
gh auth status &> /dev/null
if [ $? -ne 0 ]; then
    echo "🔑 Logging into GitHub..."
    gh auth login
else
    echo "✅ Already authenticated with GitHub."
fi

# Stage all changes
echo "📦 Staging all changes..."
git add .

# Prompt for commit message
read -p "📝 Enter a commit message: " commit_msg
git commit -m "$commit_msg"

# Prompt for GitHub remote URL
read -p "🌐 Enter the GitHub remote URL (e.g., https://github.com/UltraRepo/graph-rag.git): " remote_url

# Set or update the remote origin
git remote remove origin &> /dev/null
git remote add origin "$remote_url"
echo "🔗 Remote 'origin' set to: $remote_url"

# Confirm push
read -p "🚀 Push to GitHub remote now? (y/n): " confirm_push
if [[ "$confirm_push" == "y" || "$confirm_push" == "Y" ]]; then
    echo "📤 Pushing to GitHub..."
    git branch -M main
    git push -u origin main
    echo "✅ Push completed!"
else
    echo "❌ Push canceled. Changes committed locally."
fi