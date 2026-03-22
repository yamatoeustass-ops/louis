#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "========================================"
echo "  GitHub Setup Wizard"
echo "  ViralCaption AI"
echo "========================================"
echo ""
echo "This will help you upload your project to GitHub."
echo ""

# Check for Git
echo -e "${YELLOW}Checking Git installation...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git is NOT installed!${NC}"
    echo ""
    echo "Please install Git:"
    echo "  macOS: brew install git"
    echo "  Linux: sudo apt install git"
    exit 1
else
    echo -e "${GREEN}Git is installed!${NC}"
fi

echo ""
echo "========================================"
echo "  Step 1: Initialize Repository"
echo "========================================"
echo ""

if [ -d ".git" ]; then
    echo "Git repository already exists."
    read -p "Re-initialize? (y/n): " reinit
    if [ "$reinit" = "y" ]; then
        rm -rf .git
        echo "Removed old .git folder."
    else
        echo "Keeping existing repository."
    fi
fi

if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
    echo -e "${GREEN}Done!${NC}"
fi

echo ""
echo "========================================"
echo "  Step 2: Add Files"
echo "========================================"
echo ""

echo "Adding all files to Git..."
git add .
echo -e "${GREEN}Done!${NC}"

echo ""
echo "========================================"
echo "  Step 3: Create Commit"
echo "========================================"
echo ""

read -p "Enter commit message (or press Enter for default): " commit_msg
if [ -z "$commit_msg" ]; then
    commit_msg="Initial commit: ViralCaption AI"
fi

git commit -m "$commit_msg"
echo -e "${GREEN}Commit created!${NC}"

echo ""
echo "========================================"
echo "  Step 4: GitHub Repository"
echo "========================================"
echo ""
echo "Go to: https://github.com/new"
echo ""
echo "Create a new repository with these settings:"
echo "  - Repository name: viral_caption"
echo "  - Description: AI Transcription for Shorts, Reels & TikTok"
echo "  - Visibility: Public (recommended) or Private"
echo "  - DO NOT initialize with README"
echo ""
read -p "Open GitHub in browser? (y/n): " open_github
if [ "$open_github" = "y" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open https://github.com/new
    else
        xdg-open https://github.com/new
    fi
fi

echo ""
echo "After creating the repository, enter the URL below:"
echo ""
read -p "GitHub repository URL: " repo_url

if [ -n "$repo_url" ]; then
    echo "Setting up remote..."
    git remote add origin "$repo_url"
    echo -e "${GREEN}Remote added!${NC}"
else
    echo "No URL entered. Skipping remote setup."
fi

echo ""
echo "========================================"
echo "  Step 5: Push to GitHub"
echo "========================================"
echo ""

read -p "Push to GitHub now? (y/n): " do_push
if [ "$do_push" = "y" ]; then
    echo "Pushing to GitHub..."
    echo "(You may need to enter your GitHub credentials)"
    echo ""
    
    git branch -M main
    git push -u origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}  SUCCESS!${NC}"
        echo -e "${GREEN}========================================${NC}"
        echo ""
        echo "Your code is now on GitHub!"
        echo ""
        echo "Next step: Set up Codemagic for auto-building"
        echo "Go to: https://codemagic.io/"
        echo ""
        read -p "Open Codemagic now? (y/n): " open_codemagic
        if [ "$open_codemagic" = "y" ]; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
                open https://codemagic.io/
            else
                xdg-open https://codemagic.io/
            fi
        fi
    else
        echo ""
        echo -e "${RED}Push failed!${NC} Common issues:"
        echo "  - Authentication: Use GitHub Personal Access Token"
        echo "  - Repository URL is incorrect"
        echo "  - Repository already has commits"
        echo ""
        echo "See GITHUB_CODEMAGIC_SETUP.md for help."
    fi
else
    echo ""
    echo "You can push later with: git push -u origin main"
fi

echo ""
echo "========================================"
echo "  Setup Complete!"
echo "========================================"
echo ""
echo "Files created:"
echo "  - .gitignore (excludes sensitive files)"
echo "  - codemagic.yaml (cloud build config)"
echo "  - GITHUB_CODEMAGIC_SETUP.md (full guide)"
echo ""
echo "Next steps:"
echo "  1. Push code to GitHub (if not done)"
echo "  2. Set up Codemagic.io"
echo "  3. Build APK in the cloud!"
echo ""
