# ⚡ Quick Start: GitHub + Codemagic (5 Minutes!)

## TL;DR Version

### 1. Upload to GitHub (2 min)

**Using GitHub Desktop (Easiest):**
```
1. Download: https://desktop.github.com/
2. Install → Sign in to GitHub
3. File → Add Local Repository → Choose mobile_transcription folder
4. Commit: "Initial commit"
5. Publish repository → Name: viral_caption
6. Done! ✅
```

**OR Using Command Line:**
```bash
cd mobile_transcription
git init
git add .
git commit -m "Initial commit"
# Create repo at github.com/new (name: viral_caption)
git remote add origin https://github.com/YOUR_USERNAME/viral_caption.git
git push -u origin main
```

---

### 2. Build on Codemagic (3 min setup, 10 min build)

```
1. Go to: https://codemagic.io/
2. Sign in with GitHub
3. Add repository → Select "viral_caption"
4. Click "Start build"
5. Wait ~10-15 minutes
6. Download APK from Artifacts section
```

---

### 3. Install on Phone (2 min)

```
1. Transfer APK to Huawei phone
2. Files → Downloads → Tap APK
3. Enable "Install unknown apps" if prompted
4. Install → Done! ✅
```

---

## 🎯 That's It!

**Total Time:** ~20 minutes (mostly waiting for build)

**Next Updates:**
```bash
# Make changes → Commit → Push
git add .
git commit -m "Your changes"
git push

# Codemagic auto-builds new APK!
```

---

## 📞 If Something Goes Wrong

| Problem | Quick Fix |
|---------|-----------|
| Git not installed | `brew install git` (Mac) or `sudo apt install git` (Linux) |
| Push failed | Create repo at github.com/new first |
| Build failed | Check `codemagic.yaml` config |
| Can't install APK | Enable "Install unknown apps" in Settings |

**Full guide:** `GITHUB_CODEMAGIC_SETUP.md`

---

## 🎉 You're Done!

Every time you push to GitHub, Codemagic automatically builds a new APK!
