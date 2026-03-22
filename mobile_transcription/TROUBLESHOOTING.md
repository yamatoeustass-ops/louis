# 🔧 Troubleshooting Guide
## Common Problems & Solutions

---

## 📋 Quick Diagnostic

**What's not working?**

- [ ] Can't run setup script
- [ ] Git not installed
- [ ] Can't create GitHub repo
- [ ] Can't push to GitHub
- [ ] Codemagic build fails
- [ ] Can't download APK
- [ ] APK won't install on phone
- [ ] App crashes on phone

---

## Problem: Can't Run Setup Script

### Windows: SETUP_GITHUB.bat doesn't open

**Symptoms:**
- Double-click does nothing
- Or shows error message

**Solutions:**

**Option 1: Run from Command Prompt**
```
1. Press Windows + R
2. Type: cmd
3. Press Enter
4. Type: cd path\to\mobile_transcription
5. Type: SETUP_GITHUB.bat
6. Press Enter
```

**Option 2: Right-click → Run as Administrator**
```
1. Right-click SETUP_GITHUB.bat
2. Select "Run as administrator"
```

---

### Mac/Linux: SETUP_GITHUB.sh doesn't work

**Symptoms:**
- Double-click opens text editor
- Or shows "Permission denied"

**Solutions:**

**Option 1: Make Executable**
```bash
1. Open Terminal
2. Navigate to folder: cd path/to/mobile_transcription
3. Run: chmod +x SETUP_GITHUB.sh
4. Run: ./SETUP_GITHUB.sh
```

**Option 2: Run from Terminal**
```bash
1. Open Terminal
2. cd path/to/mobile_transcription
3. bash SETUP_GITHUB.sh
```

---

## Problem: Git Not Installed

### Windows

**Symptoms:**
```
'git' is not recognized as an internal or external command
```

**Solution:**
```
1. Go to: https://git-scm.com/download/win
2. Click "Download" (64-bit Git for Windows)
3. Run the downloaded file (Git-2.x.x-64-bit.exe)
4. Click Next → Next → Next (default settings fine)
5. Click Install
6. Click Finish
7. RESTART YOUR COMPUTER (important!)
8. Run SETUP_GITHUB.bat again
```

---

### Mac

**Symptoms:**
```
git: command not found
```

**Solution:**
```bash
1. Open Terminal
2. Type: xcode-select --install
3. Press Enter
4. Click "Install" in popup
5. Accept license
6. Wait for installation (5-10 min)
7. Run SETUP_GITHUB.sh again
```

---

### Linux

**Symptoms:**
```
git: command not found
```

**Solution:**
```bash
# Ubuntu/Debian:
sudo apt update
sudo apt install git

# Fedora:
sudo dnf install git

# Arch:
sudo pacman -S git

Then run SETUP_GITHUB.sh again
```

---

## Problem: Can't Create GitHub Repo

### Repository Name Already Taken

**Symptoms:**
```
"viral_caption" is already taken
```

**Solution:**
```
Use a different name:
- viral_caption_app
- viral_caption_ai
- YOURNAME_viral_caption
```

---

### Can't Access github.com/new

**Symptoms:**
- Page doesn't load
- 404 error

**Solution:**
```
1. Make sure you're signed in to GitHub
2. Go to: github.com
3. Click your profile picture (top right)
4. Click "Your repositories"
5. Click green "New" button
```

---

## Problem: Can't Push to GitHub

### Authentication Failed

**Symptoms:**
```
remote: Support for password authentication was removed
Please use a personal access token instead
```

**Solution: Create Personal Access Token**

```
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Enter note: "ViralCaption Build"
4. Under "Select scopes", check: ✅ repo
5. Scroll to bottom
6. Click "Generate token"
7. COPY THE TOKEN (starts with ghp_)
   ⚠️ You can't see it again!
8. Go back to terminal
9. When asked for password, paste the token
10. Press Enter
```

**To paste in terminal:**
- Windows: Right-click or Ctrl+Shift+V
- Mac: Cmd+V
- Linux: Ctrl+Shift+V or right-click

---

### Remote Already Exists

**Symptoms:**
```
fatal: remote origin already exists
```

**Solution:**
```bash
# Remove old remote:
git remote remove origin

# Add new one:
git remote add origin https://github.com/YOUR_USERNAME/viral_caption.git

# Push:
git push -u origin main
```

---

### Repository Not Found

**Symptoms:**
```
remote: Repository not found
fatal: repository not found
```

**Solution:**
```
1. Check repository URL is correct:
   git remote -v

2. If wrong, fix it:
   git remote remove origin
   git remote add origin https://github.com/YOUR_USERNAME/viral_caption.git

3. Make sure repo exists at github.com/YOUR_USERNAME/viral_caption

4. Try push again:
   git push -u origin main
```

---

## Problem: Codemagic Build Fails

### Build Timeout

**Symptoms:**
```
Build timed out after 30 minutes
```

**Solutions:**

**Option 1: Cancel and Retry**
```
1. In Codemagic, click the build
2. Click "Cancel build"
3. Click "Start build" again
```

**Option 2: Check for Infinite Loops**
```
1. Look at build logs
2. Find where it's stuck
3. Fix the issue in your code
4. Push new commit
5. New build starts automatically
```

---

### Flutter Version Error

**Symptoms:**
```
Flutter SDK not found
or
Incompatible Flutter version
```

**Solution:**
```
1. In Codemagic, go to workflow settings
2. Check "Environment" section
3. Make sure Flutter version is set to: stable
4. Or specify version in codemagic.yaml:
   flutter: 3.16.0
5. Save and rebuild
```

---

### Gradle Build Failed

**Symptoms:**
```
FAILURE: Build failed with an exception
```

**Solutions:**

**Option 1: Check build.gradle**
```
1. Open android/build.gradle
2. Check for syntax errors
3. Make sure versions are correct:
   - compileSdkVersion: 34
   - targetSdkVersion: 34
4. Commit and push changes
```

**Option 2: Clear Gradle Cache**
```
1. In Codemagic workflow settings
2. Find "Cache" section
3. Click "Clear cache"
4. Save and rebuild
```

---

### Dependencies Conflict

**Symptoms:**
```
Because package X depends on package Y which doesn't exist
```

**Solution:**
```bash
# Test locally first:
cd mobile_transcription
flutter pub get

# Fix any errors shown
# Then commit and push:
git add .
git commit -m "Fix dependencies"
git push
```

---

## Problem: Can't Download APK

### Download Link Expired

**Symptoms:**
- Download link doesn't work
- "File not found" error

**Solution:**
```
Codemagic artifacts expire after 30 days

To get new APK:
1. Go to Codemagic dashboard
2. Find your app
3. Click on latest successful build
4. Download from Artifacts section

Or trigger new build:
1. Make small change to code
2. git push
3. New build creates new APK
```

---

### Download Blocked by Browser

**Symptoms:**
- Browser says "File might be dangerous"
- Download blocked

**Solution:**
```
This is normal for APK files

Chrome:
1. Click "Keep" or "Keep anyway"
2. Or click three dots → "Keep"

Firefox:
1. Click "Save File"
2. Or right-click download link → "Save Link As"

Edge:
1. Click "Keep" or "Show more"
2. Click "Keep anyway"
```

---

## Problem: APK Won't Install

### "App not installed" Error

**Symptoms:**
- Installation fails immediately
- Shows "App not installed"

**Solutions:**

**Option 1: Enable Unknown Sources**
```
On Huawei phone:
1. Settings → Security
2. Find "Install unknown apps" or "External sources"
3. Tap "Files" or your file manager
4. Turn ON "Allow from this source"
5. Go back and try installing again
```

**Option 2: Check Storage Space**
```
1. Settings → Storage
2. Make sure you have at least 200 MB free
3. Delete some files if needed
4. Try installing again
```

**Option 3: Wrong APK Architecture**
```
Try different APK:
- app-arm64-v8a-release.apk (most phones)
- app-armeabi-v7a-release.apk (older phones)
- app-release.apk (universal, largest)
```

---

### "Parse Error" During Install

**Symptoms:**
- Shows "There was a problem parsing the package"

**Solutions:**

**Option 1: APK Corrupted**
```
1. Re-download APK from Codemagic
2. Make sure download completed
3. Try installing again
```

**Option 2: Android Version Too Old**
```
Check Android version:
1. Settings → About phone
2. Android version
3. Need Android 7.0 or higher

If older, app won't work
```

---

### "App not compatible with your phone"

**Symptoms:**
- Installation blocked
- Shows compatibility error

**Solution:**
```
Try different APK variant:

For most modern Huawei phones:
→ app-arm64-v8a-release.apk

For older phones (before 2018):
→ app-armeabi-v7a-release.apk

Universal (works on all, but larger):
→ app-release.apk
```

---

## Problem: App Crashes

### Crashes on Open

**Symptoms:**
- App opens then immediately closes
- Shows "ViralCaption AI has stopped"

**Solutions:**

**Option 1: Clear App Data**
```
1. Settings → Apps → ViralCaption AI
2. Tap "Storage"
3. Tap "Clear data"
4. Tap "Clear cache"
5. Try opening app again
```

**Option 2: Reinstall**
```
1. Uninstall app:
   Settings → Apps → ViralCaption AI → Uninstall
2. Download fresh APK from Codemagic
3. Install again
```

**Option 3: Check Android Version**
```
1. Settings → About phone
2. Android version
3. Need Android 7.0+
4. If older, app won't work
```

---

### Crashes When Uploading Video

**Symptoms:**
- App crashes when selecting video
- Or crashes during transcription

**Solutions:**

**Option 1: Grant Permissions**
```
1. Settings → Apps → ViralCaption AI
2. Tap "Permissions"
3. Enable:
   - Storage / Files
   - Media (if shown)
4. Try again
```

**Option 2: Video Format Not Supported**
```
Supported formats:
- MP4 (recommended)
- MOV
- WebM

If using other format, convert to MP4 first
```

**Option 3: Video Too Large**
```
For testing, use short videos (< 60 seconds)
Long videos may cause memory issues
```

---

## Problem: Build Takes Forever

### First Build > 30 Minutes

**Normal Times:**
- First build: 10-15 minutes
- Later builds: 5-8 minutes

**If longer than 30 minutes:**

**Solution:**
```
1. Check build logs in Codemagic
2. Look for where it's stuck
3. Common causes:
   - Downloading large files
   - Network issues
   - Complex dependencies

4. Try:
   - Cancel build
   - Wait 5 minutes
   - Start new build
```

---

### Subsequent Builds Still Slow

**Symptoms:**
- Every build takes 15+ minutes
- Cache not working

**Solution:**
```
1. In Codemagic workflow settings
2. Check "Cache" section
3. Make sure these are cached:
   - $FLUTTER_ROOT/.pub-cache
   - $HOME/.gradle/caches
4. Save workflow
5. Next build should be faster
```

---

## Still Having Problems?

### Get Help:

1. **Check Full Documentation:**
   - `COMPLETE_SETUP_GUIDE.md` - Step-by-step
   - `GITHUB_CODEMAGIC_SETUP.md` - Detailed guide
   - `README.md` - Full project docs

2. **Check Logs:**
   - Codemagic build logs
   - Terminal error messages
   - Phone logcat (advanced)

3. **Contact Support:**
   - GitHub: https://support.github.com/
   - Codemagic: https://codemagic.io/support/
   - This project: See README.md for contact

---

## Quick Reference: Common Commands

```bash
# Check Git installed:
git --version

# Check current Git status:
git status

# Fix Git remote:
git remote remove origin
git remote add origin https://github.com/USERNAME/viral_caption.git

# Push to GitHub:
git add .
git commit -m "Your message"
git push -u origin main

# Check Flutter (if installed):
flutter doctor
```

---

## Prevention Tips

**To avoid problems:**

1. ✅ Always pull latest changes before pushing
2. ✅ Test `flutter pub get` locally before pushing
3. ✅ Keep commit messages clear and descriptive
4. ✅ Wait for Codemagic build to complete before making more changes
5. ✅ Download APK soon after build (don't wait months)
6. ✅ Keep phone storage clean (at least 200 MB free)

---

**Good luck! Most problems are solvable in 5-10 minutes! 🎉**
