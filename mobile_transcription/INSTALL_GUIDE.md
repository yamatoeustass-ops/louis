# ViralCaption AI - One-Click Build & Install

## 🚀 Quick Build (Choose Your OS)

### Windows (PowerShell or CMD)

```powershell
# Open PowerShell or Command Prompt in the mobile_transcription folder
cd mobile_transcription

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# APK will be at: build\app\outputs\flutter-apk\app-release.apk
```

### macOS / Linux (Terminal)

```bash
cd mobile_transcription
flutter pub get
flutter build apk --release
# APK at: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📥 One-Click Download Page Setup

### Step 1: Build the APK
Run the commands above on your computer.

### Step 2: Copy APK to Web Folder
```powershell
# Windows PowerShell
Copy-Item "build\app\outputs\flutter-apk\app-release.apk" -Destination "web\app-release.apk"
```

```bash
# macOS / Linux
cp build/app/outputs/flutter-apk/app-release.apk web/app-release.apk
```

### Step 3: Open Download Page
```powershell
# Windows
start web\download.html
```

```bash
# macOS
open web/download.html

# Linux
xdg-open web/download.html
```

### Step 4: Download & Install
1. Click the **Download APK** button on the page
2. Transfer APK to your Huawei phone
3. Install and enjoy!

---

## 📱 Direct Install to Phone (USB)

If your phone is connected via USB:

```powershell
# Build and install in one command
flutter build apk --release && adb install build\app\outputs\flutter-apk\app-release.apk
```

---

## 🔧 Full Build Script (All-in-One)

Create `build_and_deploy.ps1` (Windows) or `build_and_deploy.sh` (Mac/Linux):

### Windows (PowerShell)
```powershell
Write-Host "🎬 ViralCaption AI - Build & Deploy" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

Write-Host "`n📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "`n🔨 Building release APK..." -ForegroundColor Yellow
flutter build apk --release

$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apkPath) {
    Write-Host "`n✅ Build successful!" -ForegroundColor Green
    Write-Host "📍 APK location: $apkPath" -ForegroundColor Green
    
    # Copy to web folder
    Copy-Item $apkPath -Destination "web\app-release.apk" -Force
    Write-Host "📄 Copied to web folder for download page" -ForegroundColor Green
    
    # Open download page
    Start-Process "web\download.html"
    Write-Host "🌐 Download page opened" -ForegroundColor Green
    
    # Check for connected device
    Write-Host "`n📱 Checking for connected devices..." -ForegroundColor Yellow
    $devices = adb devices | Select-String "device$"
    
    if ($devices) {
        Write-Host "`n🚀 Installing to connected device..." -ForegroundColor Yellow
        adb install $apkPath
        Write-Host "✅ Installation complete!" -ForegroundColor Green
    } else {
        Write-Host "`n⚠️  No device connected. Transfer APK manually." -ForegroundColor Yellow
        Write-Host "   APK ready at: $apkPath" -ForegroundColor Gray
    }
} else {
    Write-Host "`n❌ Build failed!" -ForegroundColor Red
    exit 1
}
```

### macOS / Linux (Bash)
```bash
#!/bin/bash

echo "🎬 ViralCaption AI - Build & Deploy"
echo "===================================="

echo -e "\n📦 Getting dependencies..."
flutter pub get

echo -e "\n🔨 Building release APK..."
flutter build apk --release

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    echo -e "\n✅ Build successful!"
    echo "📍 APK location: $APK_PATH"
    
    # Copy to web folder
    cp "$APK_PATH" "web/app-release.apk"
    echo "📄 Copied to web folder for download page"
    
    # Open download page
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "web/download.html"
    else
        xdg-open "web/download.html"
    fi
    echo "🌐 Download page opened"
    
    # Check for connected device
    echo -e "\n📱 Checking for connected devices..."
    if adb devices | grep -q "device$"; then
        echo -e "\n🚀 Installing to connected device..."
        adb install "$APK_PATH"
        echo "✅ Installation complete!"
    else
        echo -e "\n⚠️  No device connected. Transfer APK manually."
        echo "   APK ready at: $APK_PATH"
    fi
else
    echo -e "\n❌ Build failed!"
    exit 1
fi
```

---

## 🎯 Easiest Method (Recommended)

### Create `install.bat` (Windows) or `install.sh` (Mac/Linux):

**Windows (`install.bat`):**
```batch
@echo off
echo Building ViralCaption AI...
flutter pub get
flutter build apk --release
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo Success! Opening download page...
    copy "build\app\outputs\flutter-apk\app-release.apk" "web\app-release.apk"
    start web\download.html
    echo Download page opened. Click Download APK button.
) else (
    echo Build failed!
)
pause
```

**macOS / Linux (`install.sh`):**
```bash
#!/bin/bash
echo "Building ViralCaption AI..."
flutter pub get
flutter build apk --release
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "Success! Opening download page..."
    cp build/app/outputs/flutter-apk/app-release.apk web/app-release.apk
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open web/download.html
    else
        xdg-open web/download.html
    fi
    echo "Download page opened. Click Download APK button."
else
    echo "Build failed!"
fi
```

### Then just double-click the file! 🎉

---

## ❓ Which Terminal Should I Use?

| Your System | Use This |
|-------------|----------|
| Windows 10/11 | **PowerShell** (recommended) or CMD |
| macOS | **Terminal** (built-in) |
| Linux | **Terminal** (built-in) |
| VS Code | **Integrated Terminal** (Ctrl+`) |

### In VS Code:
1. Open the `mobile_transcription` folder
2. Press `` Ctrl + ` `` (backtick) to open terminal
3. Run the commands above

---

## 📋 Checklist

- [ ] Flutter installed (`flutter doctor`)
- [ ] Android SDK installed
- [ ] In `mobile_transcription` folder
- [ ] Run `flutter pub get`
- [ ] Run `flutter build apk --release`
- [ ] Copy APK to `web/` folder
- [ ] Open `web/download.html`
- [ ] Download APK to phone
- [ ] Install on phone

---

## 🆘 Troubleshooting

**"flutter: command not found"**
→ Install Flutter: https://docs.flutter.dev/get-started/install

**"No devices found"**
→ Enable USB debugging on phone, or just use the download page

**"Build failed"**
→ Run `flutter doctor` and fix any issues shown

**"APK not installed"**
→ Enable "Install from Unknown Sources" in phone Settings → Security
