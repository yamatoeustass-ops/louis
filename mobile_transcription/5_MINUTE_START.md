# 🎯 5-Minute Quick Start
## For People Who Don't Like Reading Manuals

---

## Do These 5 Things:

### 1️⃣ Create GitHub Account (1 min)
```
1. Go to: github.com/signup
2. Enter email → Create password → Verify
3. Done! ✅
```

---

### 2️⃣ Run the Setup Script (2 min)

**Windows:**
```
1. Open mobile_transcription folder
2. Double-click: SETUP_GITHUB.bat
3. Follow the prompts
4. When GitHub opens, create repo named: viral_caption
5. Copy the URL → Paste back in the script
6. Done! ✅
```

**Mac/Linux:**
```
1. Open mobile_transcription folder
2. Double-click: SETUP_GITHUB.sh
3. Follow the prompts
4. When GitHub opens, create repo named: viral_caption
5. Copy the URL → Paste back in the script
6. Done! ✅
```

---

### 3️⃣ Build on Codemagic (1 min setup, then wait)
```
1. Go to: codemagic.io
2. Sign in with GitHub
3. Add repository → Select "viral_caption"
4. Click "Start build"
5. Wait 10-15 minutes (go get coffee ☕)
6. Done! ✅
```

---

### 4️⃣ Download APK (30 seconds)
```
1. In Codemagic, scroll to "Artifacts"
2. Click download on: app-arm64-v8a-release.apk
3. APK downloads to your computer
4. Done! ✅
```

---

### 5️⃣ Install on Phone (2 min)
```
1. Connect phone to computer (USB cable)
2. Copy APK to phone's Download folder
3. On phone: Files → Downloads → Tap APK
4. If prompted: Enable "Install unknown apps"
5. Tap Install
6. Done! ✅
```

---

## 🎉 You're Done!

Open the app on your phone and start transcribing!

---

## If Something Breaks:

| Problem | Quick Fix |
|---------|-----------|
| Script won't run | Install Git: git-scm.com |
| Can't push to GitHub | Create repo at github.com/new first |
| Build fails | Check codemagic.yaml config |
| APK won't install | Enable "Install unknown apps" in Settings |

**Full guide:** `COMPLETE_SETUP_GUIDE.md`

---

## For Updates:

```bash
# Make changes → Save → Run these:
git add .
git commit -m "Your changes"
git push

# Codemagic auto-builds new APK!
```

---

**That's it! No Flutter needed, no complex setup!** 🚀
