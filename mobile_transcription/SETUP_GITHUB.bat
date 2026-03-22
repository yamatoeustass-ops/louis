@echo off
color 0B
title GitHub Setup - ViralCaption AI

echo.
echo ========================================
echo   GitHub Setup Wizard
echo   ViralCaption AI
echo ========================================
echo.
echo This will help you upload your project to GitHub.
echo.
echo BEFORE WE START:
echo - Do you have a GitHub account? (Y/N)
echo.
set /p has_account="Your answer: "

if /i "%has_account%"=="N" (
    echo.
    echo Opening GitHub signup page...
    start https://github.com/signup
    echo.
    echo After creating your account, come back and run this script again.
    pause
    exit /b 0
)

echo.
echo ========================================
echo   Step 1: Check Git Installation
echo ========================================
echo.

where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Git is NOT installed!
    echo.
    echo Please install Git from: https://git-scm.com/download/win
    echo.
    set /p install_git="Open download page now? (Y/N): "
    if /i "%install_git%"=="Y" start https://git-scm.com/download/win
    pause
    exit /b 1
) else (
    echo Git is installed!
)

echo.
echo ========================================
echo   Step 2: Initialize Repository
echo ========================================
echo.

if exist ".git" (
    echo Git repository already exists.
    set /p reinit="Re-initialize? (Y/N): "
    if /i "%reinit%"=="Y" (
        rmdir /s /q .git
        echo Removed old .git folder.
    ) else (
        echo Keeping existing repository.
    )
)

if not exist ".git" (
    echo Initializing Git repository...
    git init
    echo Done!
)

echo.
echo ========================================
echo   Step 3: Add Files
echo ========================================
echo.

echo Adding all files to Git...
git add .
echo Done!

echo.
echo ========================================
echo   Step 4: Create Commit
echo ========================================
echo.

set /p commit_msg="Enter commit message (or press Enter for default): "
if "%commit_msg%"=="" set commit_msg=Initial commit: ViralCaption AI

git commit -m "%commit_msg%"
echo Commit created!

echo.
echo ========================================
echo   Step 5: GitHub Repository
echo ========================================
echo.
echo Go to: https://github.com/new
echo.
echo Create a new repository with these settings:
echo   - Repository name: viral_caption
echo   - Description: AI Transcription for Shorts, Reels ^& TikTok
echo   - Visibility: Public (recommended) or Private
echo   - DO NOT initialize with README
echo.
set /p open_github="Open GitHub now? (Y/N): "
if /i "%open_github%"=="Y" start https://github.com/new

echo.
echo After creating the repository, enter the URL below:
echo.
set /p repo_url="GitHub repository URL (e.g., https://github.com/yourname/viral_caption): "

if "%repo_url%"=="" (
    echo No URL entered. Skipping remote setup.
    goto :next_step
)

echo Setting up remote...
git remote add origin %repo_url%
echo Remote added!

:next_step
echo.
echo ========================================
echo   Step 6: Push to GitHub
echo ========================================
echo.

set /p do_push="Push to GitHub now? (Y/N): "
if /i "%do_push%"=="Y" (
    echo Pushing to GitHub...
    echo (You may need to enter your GitHub credentials)
    echo.
    
    git branch -M main
    git push -u origin main
    
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ========================================
        echo   SUCCESS!
        echo ========================================
        echo.
        echo Your code is now on GitHub!
        echo.
        echo Next step: Set up Codemagic for auto-building
        echo Go to: https://codemagic.io/
        echo.
        set /p open_codemagic="Open Codemagic now? (Y/N): "
        if /i "%open_codemagic%"=="Y" start https://codemagic.io/
    ) else (
        echo.
        echo Push failed! Common issues:
        echo - Authentication: Use GitHub Personal Access Token
        echo - Repository URL is incorrect
        echo - Repository already has commits (use --force with caution)
        echo.
        echo See GITHUB_CODEMAGIC_SETUP.md for help.
    )
) else (
    echo.
    echo You can push later with: git push -u origin main
)

echo.
echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo Files created:
echo - .gitignore (excludes sensitive files)
echo - codemagic.yaml (cloud build config)
echo - GITHUB_CODEMAGIC_SETUP.md (full guide)
echo.
echo Next steps:
echo 1. Push code to GitHub (if not done)
echo 2. Set up Codemagic.io
echo 3. Build APK in the cloud!
echo.

pause
