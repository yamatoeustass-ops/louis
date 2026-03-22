# 🚀 START HERE - One-Click Install for Huawei

## ⚡ NO FLUTTER? No Problem!

**Don't have Flutter installed?** Use cloud building!

### 🎯 Fastest Way (5 min setup + 10 min build):

```
Step 1: Run the GitHub setup script
├─ Windows: Double-click SETUP_GITHUB.bat
└─ Mac/Linux: Double-click SETUP_GITHUB.sh

Step 2: Build on Codemagic (cloud)
├─ Go to: codemagic.io
├─ Sign in with GitHub
├─ Add your "viral_caption" repo
└─ Click "Start build" → Wait ~10 min

Step 3: Download & Install
├─ Download APK from Codemagic
├─ Transfer to Huawei phone
└─ Install → Done!
```

📖 **Quick guide:** `QUICK_GITHUB_SETUP.md`  
📖 **Full guide:** `GITHUB_CODEMAGIC_SETUP.md`

---

## 🛠️ Have Flutter? Build Locally:

### Windows Users:
1. **Double-click** `BUILD.bat`
2. Wait for build to complete (~2-5 minutes first time)
3. Download page opens automatically → Click **"Download APK"**

### Mac/Linux Users:
1. **Double-click** `BUILD.sh` (or run `./BUILD.sh`)
2. Wait for build to complete (~2-5 minutes first time)
3. Download page opens automatically → Click **"Download APK"**

---

## What You Need First Time

| Requirement | How to Get |
|-------------|------------|
| **Flutter SDK** | https://docs.flutter.dev/get-started/install |
| **Android SDK** | Comes with Android Studio |
| **Java JDK 17** | https://adoptium.net/ |

### Check if Ready:
```bash
flutter doctor
```

If all checks pass ✅, you're ready to build!

---

## After Building

### Transfer APK to Huawei Phone:

**Method 1: USB Cable**
```
1. Connect phone to computer
2. Copy downloaded APK to phone
3. On phone: Files → Download → Tap APK → Install
```

**Method 2: Direct Install (USB Debugging)**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Method 3: Cloud/Email**
```
1. Upload APK to Google Drive / Email
2. Download on phone
3. Tap to install
```

---

## First Time Installation on Huawei

1. **Download APK** from the download page
2. **Open Files app** → Downloads
3. **Tap the APK file**
4. If prompted: **Settings → Security → Enable "Install from Unknown Sources"**
5. **Tap Install**
6. **Open** ViralCaption AI

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Flutter not found" | Install Flutter SDK, add to PATH |
| "Build failed" | Run `flutter doctor` and fix issues |
| "Can't install APK" | Enable "Install from Unknown Sources" |
| "App crashes" | Check phone has Android 7.0+ |

---

## File Locations

| File | Location |
|------|----------|
| Build script (Windows) | `BUILD.bat` |
| Build script (Mac/Linux) | `BUILD.sh` |
| Download page | `web/download.html` |
| Built APK | `build/app/outputs/flutter-apk/app-release.apk` |
| Web copy | `web/app-release.apk` |

---

## Need Help?

- Full docs: `README.md`
- Huawei setup: `HUAWEI_SETUP.md`
- Quick start: `QUICKSTART.md`

---

**Made for Huawei phones • Works offline • No Google Services needed**
