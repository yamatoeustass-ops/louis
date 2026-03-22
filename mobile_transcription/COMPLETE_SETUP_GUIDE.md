# 📘 Complete GitHub + Codemagic Setup Guide
## Step-by-Step with Every Single Click Explained

---

## 📖 Table of Contents

1. [Create GitHub Account](#part-1-create-github-account)
2. [Upload Code to GitHub](#part-2-upload-code-to-github)
3. [Set Up Codemagic](#part-3-set-up-codemagic)
4. [Download & Install APK](#part-4-download--install-apk)
5. [Troubleshooting](#troubleshooting)

---

## Part 1: Create GitHub Account

### Step 1.1: Go to GitHub

**What to do:**
1. Open your web browser (Chrome, Firefox, Edge, etc.)
2. In the address bar, type: `https://github.com`
3. Press **Enter**

**What you'll see:**
- GitHub homepage with login form

---

### Step 1.2: Sign Up for New Account

**What to do:**
1. Click the **"Sign up"** button (top right corner)
2. Enter your email address in the box
3. Click **"Continue"**

**What happens next:**
- GitHub will ask you to create a password
- Type a strong password (mix of letters, numbers, symbols)
- Click **"Continue"**

---

### Step 1.3: Verify Your Account

**What to do:**
1. GitHub will show you a puzzle (security check)
2. Solve the puzzle (usually slide or select images)
3. Click **"Verify"**

**What happens next:**
- GitHub sends a code to your email

---

### Step 1.4: Enter Verification Code

**What to do:**
1. Open your email in a new tab
2. Find email from GitHub (subject: "Your GitHub verification code")
3. Copy the 6-digit code
4. Go back to GitHub tab
5. Paste the code in the verification box
6. Click **"Continue"**

**What happens next:**
- GitHub asks for a username

---

### Step 1.5: Choose Username

**What to do:**
1. Think of a username (e.g., `john_dev`, `myapps2024`)
2. Type it in the username box
3. GitHub will show if it's available (green checkmark)
4. If taken, try a different username
5. Click **"Continue"**

**What happens next:**
- GitHub asks if you want email updates
- You can skip this (click "Skip" or uncheck boxes)

---

### Step 1.6: Account Created!

**What you'll see:**
- Welcome message
- Button to "Complete your profile" (optional)
- You can skip this for now

**✅ Success!** You now have a GitHub account!

---

## Part 2: Upload Code to GitHub

### Option A: Using SETUP_GITHUB.bat (Windows - Easiest!)

### Step 2.A.1: Open the Project Folder

**What to do:**
1. Open **File Explorer** (Windows key + E)
2. Navigate to your project folder
3. Open the `mobile_transcription` folder

**What you'll see:**
- Many files and folders:
  - `lib/` folder
  - `android/` folder
  - `SETUP_GITHUB.bat` file ← This is what we need!

---

### Step 2.A.2: Run the Setup Script

**What to do:**
1. Find the file named `SETUP_GITHUB.bat`
2. **Double-click** on it

**What happens:**
- A black window (Command Prompt) opens
- You'll see text like:
  ```
  ========================================
    GitHub Setup Wizard
    ViralCaption AI
  ========================================
  ```

---

### Step 2.A.3: Answer the Questions

The script will ask you questions. Here's what to type:

**Question 1:** "Do you have a GitHub account? (Y/N)"
- If you created account in Part 1: Type `Y` and press Enter
- If not: Type `N` and press Enter (it will open signup page)

**Question 2:** "Git is NOT installed! Open download page?"
- If Git not installed: Type `Y` and press Enter
- Follow the Git installation instructions (see below)
- After installing Git, run `SETUP_GITHUB.bat` again

**Question 3:** "Enter commit message"
- You can just press **Enter** (uses default message)
- Or type your own message like "First version"

**Question 4:** "Open GitHub now? (Y/N)"
- Type `Y` and press Enter
- GitHub website opens in your browser

---

### Step 2.A.4: Create Repository on GitHub

**What you'll see:**
- GitHub page titled "Create a new repository"

**What to do:**
1. **Repository name:** Type `viral_caption`
2. **Description:** Type `AI Transcription for Shorts, Reels & TikTok`
3. **Visibility:** Choose **Public** (free, anyone can see) or **Private** (only you)
4. **DO NOT check** "Add a README file"
5. **DO NOT check** "Add .gitignore"
6. **DO NOT check** "Choose a license"
7. Click the green **"Create repository"** button

**What happens:**
- Repository is created
- You'll see your repository page

---

### Step 2.A.5: Copy Repository URL

**What you'll see:**
- On the GitHub page, look for text that says:
  `https://github.com/YOUR_USERNAME/viral_caption.git`

**What to do:**
1. Click the **copy icon** next to the URL
2. Go back to the black setup window
3. It will ask: "GitHub repository URL:"
4. **Right-click** in the black window to paste (or Ctrl+V)
5. Press **Enter**

---

### Step 2.A.6: Push to GitHub

**What the script asks:**
"Push to GitHub now? (Y/N)"

**What to do:**
- Type `Y` and press Enter

**What happens:**
- GitHub may ask for username and password:
  - **Username:** Your GitHub username
  - **Password:** Use a **Personal Access Token** (not your regular password!)

**If you need a Personal Access Token:**
1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token (classic)"**
3. Give it a name: `ViralCaption Build`
4. Check the box **"repo"** (full control of private repositories)
5. Scroll down, click **"Generate token"**
6. **COPY THE TOKEN** (starts with `ghp_...`) - you can't see it again!
7. Use this token as your password

**What you'll see when done:**
```
========================================
  SUCCESS!
========================================

Your code is now on GitHub!
```

---

### Option B: Using SETUP_GITHUB.sh (Mac/Linux)

Same steps as Windows, but:
1. Double-click `SETUP_GITHUB.sh` instead
2. If it doesn't open, right-click → Open With → Terminal
3. Or open Terminal, navigate to folder, run: `./SETUP_GITHUB.sh`

---

### Option C: Manual Upload (If Scripts Don't Work)

### Step 2.C.1: Install Git

**Windows:**
1. Go to: https://git-scm.com/download/win
2. Click **"Download"**
3. Run the downloaded file
4. Click **Next, Next, Next** (default settings are fine)
5. Click **Install**
6. Click **Finish**

**Mac:**
1. Open **Terminal** (Cmd+Space, type "Terminal")
2. Type: `xcode-select --install`
3. Press Enter
4. Click **Install** in the popup

**Linux:**
1. Open Terminal
2. Type: `sudo apt update && sudo apt install git`
3. Press Enter
4. Type your password

---

### Step 2.C.2: Open Terminal/Command Prompt

**Windows:**
1. Press **Windows key + R**
2. Type `cmd`
3. Press Enter

**Mac:**
1. Press **Cmd + Space**
2. Type `Terminal`
3. Press Enter

**Linux:**
1. Press **Ctrl + Alt + T**

---

### Step 2.C.3: Navigate to Project Folder

**What to type:**
```bash
cd path/to/mobile_transcription
```

**How to find the path:**
- **Windows:** In File Explorer, click address bar, copy the path
- **Mac:** In Finder, right-click folder, hold Option, click "Copy as Pathname"
- **Linux:** In file manager, right-click → Properties → Parent folder

**Example:**
```bash
cd C:\Users\YourName\Documents\mobile_transcription
```
or
```bash
cd /home/username/projects/mobile_transcription
```

---

### Step 2.C.4: Initialize Git Repository

**Type these commands one by one:**

```bash
git init
```
(Press Enter after each command)

You'll see: `Initialized empty Git repository`

---

### Step 2.C.5: Add All Files

```bash
git add .
```

This adds all files to Git.

---

### Step 2.C.6: Create First Commit

```bash
git commit -m "Initial commit: ViralCaption AI"
```

You'll see something like:
```
[master (root-commit) abc123] Initial commit: ViralCaption AI
 50 files changed, 5000 insertions(+)
```

---

### Step 2.C.7: Create GitHub Repository

**What to do:**
1. Open browser
2. Go to: https://github.com/new
3. **Repository name:** `viral_caption`
4. **Description:** `AI Transcription for Shorts, Reels & TikTok`
5. **Visibility:** Public or Private
6. **DO NOT** initialize with README
7. Click **"Create repository"**

---

### Step 2.C.8: Connect to GitHub

**Copy and paste these commands:**

(Replace `YOUR_USERNAME` with your actual GitHub username)

```bash
git remote add origin https://github.com/YOUR_USERNAME/viral_caption.git
```

Then:

```bash
git branch -M main
```

Then:

```bash
git push -u origin main
```

**If asked for password:**
- Use Personal Access Token (see Step 2.A.6)

---

### Step 2.C.9: Verify Upload

**What to do:**
1. Go to: https://github.com/YOUR_USERNAME/viral_caption
2. You should see all your files!
3. Check for files like:
   - `lib/main.dart`
   - `pubspec.yaml`
   - `android/app/build.gradle`

**✅ Success!** Your code is on GitHub!

---

## Part 3: Set Up Codemagic

### Step 3.1: Go to Codemagic

**What to do:**
1. Open your browser
2. Go to: https://codemagic.io/
3. Press Enter

**What you'll see:**
- Codemagic homepage
- "Start building" button

---

### Step 3.2: Sign In with GitHub

**What to do:**
1. Click **"Sign in"** (top right)
2. Click **"Sign in with GitHub"** button
3. GitHub will ask: "Authorize Codemagic?"
4. Click **"Authorize Codemagic"**

**What happens:**
- You're signed in to Codemagic
- You'll see your GitHub repositories

---

### Step 3.3: Add Your Repository

**What to do:**
1. Click **"Add repository"** or **"New project"**
2. Find `viral_caption` in the list
3. Click on it
4. Click **"Add repository"** button

**What you'll see:**
- Repository settings page
- Your repository name at top

---

### Step 3.4: Configure Build Settings

Codemagic auto-detects Flutter, but let's verify:

**What to do:**
1. Scroll down to **"Workflow settings"**
2. Click on it (if collapsed)

**Check these settings:**

**Build name:** 
- Should show: `Build APK` (from codemagic.yaml)

**Environment variables:**
- No need to add anything

**Build commands:**
- Should be auto-filled from `codemagic.yaml`
- You'll see commands like:
  ```
  flutter pub get
  flutter build apk --release
  ```

**Artifacts:**
- Should show: `build/app/outputs/flutter-apk/*.apk`

---

### Step 3.5: Save Workflow

**What to do:**
1. Scroll to bottom of page
2. Click **"Save workflow"** button

**What happens:**
- Workflow is saved
- You're taken to the build page

---

### Step 3.6: Start Your First Build

**What to do:**
1. Click **"Start build"** button (green, top right)
2. A popup appears asking for build name
3. You can leave it as default or type "First build"
4. Click **"Start build"**

**What happens:**
- Build starts
- You'll see a progress screen

---

### Step 3.7: Watch Build Progress

**What you'll see:**
- Multiple steps with checkboxes:
  - ✅ Cloning repository
  - 🔄 Installing Flutter
  - ⏳ Getting dependencies
  - ⏳ Building APK
  - ⏳ Uploading artifacts

**How long it takes:**
- **First build:** 10-15 minutes
- **Later builds:** 5-8 minutes (uses cache)

**What's happening:**
1. Codemagic creates a virtual machine
2. Installs Flutter SDK
3. Installs Android SDK
4. Downloads your dependencies
5. Builds your APK
6. Uploads APK for download

---

### Step 3.8: Build Complete!

**What you'll see:**
- Green checkmark ✅
- Text: "Build successful"
- Section: **"Artifacts"**

**In Artifacts section:**
- List of APK files:
  - `app-release.apk` (universal, ~50-60 MB)
  - `app-arm64-v8a-release.apk` (~20 MB) ← Recommended
  - `app-armeabi-v7a-release.apk` (~18 MB)
  - `app-x86_64-release.apk` (~22 MB)

---

### Step 3.9: Download APK

**What to do:**
1. Find `app-arm64-v8a-release.apk` (best for most phones)
2. Click the **download icon** (arrow pointing down)
3. APK downloads to your computer

**Where it saves:**
- **Windows:** `Downloads` folder
- **Mac:** `Downloads` folder
- **Linux:** `Downloads` folder

**✅ Success!** You now have the APK!

---

## Part 4: Download & Install APK

### Step 4.1: Transfer APK to Phone

**Method 1: USB Cable (Recommended)**

**What to do:**
1. Connect your Huawei phone to computer with USB cable
2. On phone, swipe down from top
3. Tap "USB charging this device"
4. Select **"File transfer"** or **"Transfer files"**
5. On computer:
   - **Windows:** Open File Explorer → Your phone name → Internal storage → Download
   - **Mac:** Open Android File Transfer → Internal storage → Download
6. Copy the APK file from your computer's Downloads
7. Paste into phone's Download folder

---

**Method 2: Email**

**What to do:**
1. Open your email (Gmail, Outlook, etc.)
2. Compose new email
3. Attach the APK file
4. Send to yourself
5. On phone, open email app
6. Open the email
7. Tap the APK attachment
8. Tap Download

---

**Method 3: Cloud Storage**

**What to do:**
1. Upload APK to Google Drive, Dropbox, or Huawei Cloud
2. On phone, open the cloud app
3. Find the APK file
4. Tap to download

---

### Step 4.2: Install APK on Phone

**What to do:**
1. On your Huawei phone, open **"Files"** app
2. Tap **"Downloads"** or **"Internal storage" → "Download"**
3. Find the APK file (e.g., `app-arm64-v8a-release.apk`)
4. **Tap on it**

---

### Step 4.3: Enable "Install Unknown Apps" (If Prompted)

**What you might see:**
- Warning: "For security, your phone is not allowed to install unknown apps from this source"

**What to do:**
1. Tap **"Settings"** (on the popup)
2. You'll see "Allow from this source" toggle
3. **Turn it ON** (tap the switch)
4. Go back (back arrow)
5. Tap **"Install"**

---

### Step 4.4: Install the App

**What you'll see:**
- App permissions screen
- Shows what the app needs access to

**What to do:**
1. Review permissions (should be: Storage, Media)
2. Tap **"Install"** at bottom
3. Wait for installation (5-10 seconds)
4. When done, you'll see "App installed"

---

### Step 4.5: Open the App

**What to do:**
1. Tap **"Open"** button
2. Or find "ViralCaption AI" in your app drawer
3. Tap to open

**✅ Success!** The app is installed!

---

## Part 5: Using the App

### First Time Setup

**When you open the app:**

1. **Welcome screen** appears
2. App asks for permissions:
   - **Storage/Media:** Tap "Allow" (needed to access videos)

---

### Transcribe Your First Video

**Step 1: Upload Video**
1. Tap the upload box (dashed border)
2. Select a video from your phone
3. Video preview appears

**Step 2: Choose Transcription Mode**
1. Tap Settings (gear icon)
2. Choose mode:
   - **Auto:** Smart selection (recommended)
   - **On-Device:** Works offline (download model first)
   - **Cloud:** Faster (needs internet)

**Step 3: Start Transcription**
1. Tap **"Transcribe Video"** button
2. Wait for processing (30 seconds - 2 minutes)
3. Progress bar shows percentage

**Step 4: View Results**
1. Word-level captions appear
2. Each word shows timestamp
3. Full text at bottom

**Step 5: Export**
1. Tap menu (three dots, top right)
2. Choose format:
   - **SRT:** Standard subtitles
   - **ASS:** Animated karaoke style
   - **JSON:** For editors
3. Tap format → Share or Save

---

## Troubleshooting

### Problem: "Git is not recognized"

**Solution:**
1. Install Git (see Step 2.C.1)
2. After installing, **restart your computer**
3. Try running `SETUP_GITHUB.bat` again

---

### Problem: "Authentication failed" when pushing

**Solution:**
1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token (classic)"**
3. Name: `ViralCaption`
4. Check box: **"repo"** (full control)
5. Click **"Generate token"**
6. **Copy the token** (starts with `ghp_...`)
7. When asked for password, **paste the token** instead

---

### Problem: "Build failed" on Codemagic

**Solution:**
1. In Codemagic, click on the failed build
2. Scroll to **"Build logs"**
3. Look for red text or errors
4. Common fixes:
   - **"pubspec.yaml error":** Check file for typos
   - **"Gradle error":** Check `android/build.gradle`
   - **"Out of memory":** Contact Codemagic support

---

### Problem: "APK won't install"

**Solution:**
1. Go to phone **Settings**
2. Tap **"Security"** or **"Privacy"**
3. Find **"Install unknown apps"** or **"External sources"**
4. Tap **"Files"** or your file manager app
5. Turn **"Allow from this source"** ON
6. Try installing APK again

---

### Problem: "App crashes on open"

**Solution:**
1. Check your Android version:
   - Settings → About phone → Android version
   - Need Android 7.0 or higher
2. Try clearing app data:
   - Settings → Apps → ViralCaption AI → Storage → Clear data
3. Reinstall the app

---

### Problem: "Build takes too long"

**Normal times:**
- First build: 10-15 minutes
- Later builds: 5-8 minutes

**If longer than 20 minutes:**
1. Check Codemagic dashboard for errors
2. Build might be stuck - cancel and retry
3. Contact Codemagic support if persistent

---

## 🎉 You're Done!

### What You Accomplished:
✅ Created GitHub account  
✅ Uploaded code to GitHub  
✅ Set up Codemagic cloud build  
✅ Built Android APK  
✅ Installed on Huawei phone  

### Next Steps:
- Test the app with your videos
- Make changes to code
- Push to GitHub → Codemagic auto-builds!
- Share with friends!

---

## 📞 Need More Help?

| Resource | Link |
|----------|------|
| GitHub Help | https://docs.github.com/ |
| Codemagic Docs | https://docs.codemagic.io/ |
| This Project Docs | See all `.md` files in project |
| GitHub Support | https://support.github.com/ |
| Codemagic Support | https://codemagic.io/support/ |

---

**Congratulations! You've successfully set up cloud building for your app! 🎊**
