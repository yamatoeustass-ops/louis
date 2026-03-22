@echo off
color 0B
title ViralCaption AI - One-Click Build & Install

echo.
echo ========================================
echo   ViralCaption AI - Build ^& Install
echo ========================================
echo.

echo [1/4] Getting dependencies...
call flutter pub get
if errorlevel 1 (
    echo.
    echo ERROR: Failed to get dependencies!
    echo Make sure Flutter is installed and in PATH.
    pause
    exit /b 1
)

echo.
echo [2/4] Building release APK...
call flutter build apk --release
if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    echo Run 'flutter doctor' to check your setup.
    pause
    exit /b 1
)

echo.
echo [3/4] Copying APK to web folder...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    copy /Y "build\app\outputs\flutter-apk\app-release.apk" "web\app-release.apk" >nul
    echo SUCCESS: APK copied to web folder!
) else (
    echo ERROR: APK not found!
    pause
    exit /b 1
)

echo.
echo [4/4] Opening download page...
start web\download.html

echo.
echo ========================================
echo   BUILD COMPLETE!
echo ========================================
echo.
echo Next steps:
echo 1. Click the "Download APK" button on the webpage
echo 2. Transfer the APK to your Huawei phone
echo 3. Install and enjoy!
echo.
echo APK location: %CD%\build\app\outputs\flutter-apk\app-release.apk
echo.

pause
