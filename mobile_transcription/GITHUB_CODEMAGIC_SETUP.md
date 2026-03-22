# 🚀 GitHub + Codemagic Setup Guide

## Complete Step-by-Step Instructions

---

## Part 1: Create GitHub Repository

### Step 1: Create GitHub Account (if you don't have one)
```
1. Go to: https://github.com/signup
2. Enter email, username, password
3. Verify email
4. Done!
```

### Step 2: Create New Repository
```
1. Go to: https://github.com/new
2. Repository name: viral_caption
3. Description: "AI Transcription for Shorts, Reels & TikTok"
4. Visibility: Public (free) or Private
5. DO NOT initialize with README (we already have code)
6. Click "Create repository"
```

### Step 3: Upload Your Code

**Option A: Using Git Command Line (Recommended)**

Open terminal/PowerShell in the `mobile_transcription` folder:

```bash
# Initialize git repo
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial commit: ViralCaption AI app"

# Connect to GitHub (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/viral_caption.git

# Upload to GitHub
git push -u origin main
```

If it says "main" doesn't exist:
```bash
git branch -M main
git push -u origin main
```

**Option B: Using GitHub Desktop (Easier)**

```
1. Download: https://desktop.github.com/
2. Install and sign in
3. File → Add Local Repository → Choose mobile_transcription folder
4. Commit message: "Initial commit"
5. Publish repository → Name: viral_caption
6. Click "Publish repository"
```

**Option C: Upload Files Manually**

```
1. In your new GitHub repo, click "uploading an existing file"
2. Drag and drop all files from mobile_transcription folder
3. Commit message: "Initial commit"
4. Click "Commit changes"
```

---

## Part 2: Set Up Codemagic (Cloud Build)

### Step 4: Create Codemagic Account
```
1. Go to: https://codemagic.io/
2. Click "Sign in"
3. Choose "Sign in with GitHub"
4. Authorize Codemagic to access GitHub
```

### Step 5: Add Your Repository
```
1. In Codemagic dashboard, click "Add repository"
2. Find "viral_caption" in the list
3. Click "Add repository" button
```

### Step 6: Configure Build Settings

**In Codemagic, go to "Workflow settings":**

1. **Workflow name:** `Build APK`

2. **Build triggers:** 
   - Keep default (build on push)

3. **Environment variables:**
   - Click "Add variable"
   - No need to add anything for basic build

4. **Build commands:** 
   - Codemagic auto-detects Flutter!
   - But you can customize in `codemagic.yaml` (already created)

5. **Artifacts:**
   - Codemagic will auto-detect APKs
   - They appear after successful build

6. Click **"Save workflow"**

### Step 7: Start Your First Build
```
1. Go to "Triggers" tab
2. Click "Start build"
3. Wait ~10-15 minutes (first build downloads everything)
4. Watch build progress in real-time
5. When done, download APK from "Artifacts" section
```

---

## Part 3: Download & Install APK

### Step 8: Get Your APK
```
1. In Codemagic, go to your build
2. Scroll to "Artifacts" section
3. You'll see:
   - app-release.apk (universal, ~50-60 MB)
   - app-arm64-v8a-release.apk (for most modern phones)
   - app-armeabi-v7a-release.apk (for older phones)
4. Click to download the universal one
```

### Step 9: Install on Huawei Phone

**Method A: USB Cable**
```
1. Connect phone to computer via USB
2. Copy downloaded APK to phone's Download folder
3. On phone: Open "Files" app
4. Go to Downloads → Tap the APK file
5. If prompted: Settings → Security → Enable "Install unknown apps"
6. Tap "Install"
7. Wait → Tap "Open" to launch ViralCaption AI
```

**Method B: Email/Cloud**
```
1. Email APK to yourself OR upload to Google Drive/Huawei Cloud
2. On phone: Open email/Drive app
3. Download the APK
4. Tap to install
```

**Method C: QR Code (Fancy!)**
```
1. Upload APK to a web server or cloud storage
2. Get the download link
3. Create QR code: https://www.qr-code-generator.com/
4. On phone: Scan QR code → Download → Install
```

---

## Part 4: Auto-Build on Every Update

### Step 10: Enable Automatic Builds

Codemagic is already configured to build automatically!

```
Every time you push to GitHub:
1. Make changes to your code
2. git add . && git commit -m "Your changes"
3. git push
4. Codemagic automatically builds new APK
5. Download from Codemagic dashboard
```

### Optional: GitHub Releases (Auto-Publish)

The `.github/workflows/build.yml` file creates GitHub Releases automatically.

To use GitHub Actions instead of Codemagic:
```
1. Go to your repo on GitHub
2. Click "Actions" tab
3. Enable workflows
4. Push a new commit to trigger build
5. APK appears in "Artifacts" section
```

---

## Part 5: Customize Build (Optional)

### Change App Name
Edit `android/app/src/main/res/values/strings.xml`:
```xml
<string name="app_name">Your App Name</string>
```

### Change Package Name
Edit these files:
- `pubspec.yaml`
- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`
- Folder: `android/app/src/main/kotlin/com/viralcaption/viral_caption/`

### Add Huawei AGConnect
1. Download `agconnect-services.json` from AppGallery Connect
2. Place in `android/app/`
3. Update App ID in `build.gradle`
4. Commit and push - Codemagic will build with HMS!

---

## Troubleshooting

### ❌ Build Failed: "Flutter SDK not found"
**Solution:** Codemagic auto-detects Flutter. Check `codemagic.yaml` has correct Flutter version.

### ❌ Build Failed: "Gradle error"
**Solution:** Check `android/build.gradle` and `android/app/build.gradle` for syntax errors.

### ❌ Build Failed: "Dependencies conflict"
**Solution:** Run `flutter pub get` locally to check for dependency issues.

### ❌ Build Takes Too Long
**Solution:** First build is slow (~15 min). Subsequent builds are faster (~5 min) due to caching.

### ❌ APK Too Large
**Solution:** Use `--split-per-abi` (already configured) to create smaller architecture-specific APKs.

---

## Quick Reference

### Upload to GitHub
```bash
cd mobile_transcription
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/viral_caption.git
git push -u origin main
```

### Update After Changes
```bash
git add .
git commit -m "Your changes"
git push
```

### Links You Need
| Service | URL |
|---------|-----|
| GitHub | https://github.com |
| Codemagic | https://codemagic.io |
| Flutter Download | https://docs.flutter.dev/get-started/install |

---

## What Happens Next?

```
Day 1:
✅ Upload to GitHub
✅ Set up Codemagic
✅ First build runs (~15 min)
✅ Download APK
✅ Install on phone

Day 2+:
✅ Make changes to code
✅ git push
✅ Codemagic auto-builds (~5 min)
✅ Download new APK
✅ Test updates
```

---

## Need Help?

- **Codemagic Docs:** https://docs.codemagic.io/
- **Flutter Docs:** https://docs.flutter.dev/
- **GitHub Docs:** https://docs.github.com/
- **This Project:** See `README.md`, `START_HERE.md`

---

**You're all set! 🎉 Upload to GitHub and let Codemagic do the building!**
