@echo off
color 0A
title ViralCaption AI - Pre-built APK Installer

echo.
echo ========================================
echo   ViralCaption AI - APK Installer
echo ========================================
echo.
echo This will help you install the app WITHOUT building.
echo.
echo OPTION 1: Download Pre-built APK from GitHub
echo ----------------------------------------------
echo 1. Go to: https://github.com/YOUR_USERNAME/viral_caption/releases
echo 2. Download the latest app-release.apk
echo 3. Transfer to your phone and install
echo.
echo OPTION 2: Use Online Build Service
echo ----------------------------------------------
echo 1. Go to: https://codemagic.io/ or https://appetize.io/
echo 2. Upload this project folder
echo 3. They will build the APK for you
echo.
echo OPTION 3: Install Flutter (For Building Yourself)
echo ----------------------------------------------
echo 1. Download Flutter SDK:
echo    https://docs.flutter.dev/get-started/install/windows
echo.
echo 2. Extract to: C:\src\flutter
echo.
echo 3. Add Flutter to PATH:
echo    - Right-click "This PC" → Properties
echo    - Advanced system settings → Environment Variables
echo    - Under "System variables", find "Path" → Edit
echo    - New → Add: C:\src\flutter\bin
echo    - OK → OK → OK
echo.
echo 4. Restart this script
echo.
echo ========================================
echo.

:choice
echo What would you like to do?
echo.
echo 1. Open GitHub Releases (to download pre-built APK)
echo 2. Open Flutter Download Page
echo 3. Open Codemagic (online build)
echo 4. Exit
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" start https://github.com/YOUR_USERNAME/viral_caption/releases
if "%choice%"=="2" start https://docs.flutter.dev/get-started/install/windows
if "%choice%"=="3" start https://codemagic.io/
if "%choice%"=="4" exit

echo.
goto choice
