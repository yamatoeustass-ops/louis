# ViralCaption AI - Mobile App

AI-powered transcription app for Shorts, Reels & TikTok with **hybrid on-device + cloud** processing.

## Features

- ✅ **Word-level timestamps** for karaoke-style captions
- ✅ **Hybrid transcription**: On-device (offline) + Cloud fallback
- ✅ **Huawei HMS** integration (AppGallery ready)
- ✅ **Multiple export formats**: SRT, ASS (animated), JSON
- ✅ **Offline support** with whisper.cpp
- ✅ **Vertical video optimized** (9:16 aspect ratio)

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Flutter App                        │
├─────────────────────────────────────────────────────┤
│  UI Layer                                            │
│  ├── Home Screen (Video Upload)                     │
│  ├── Caption Editor (Word-level editing)            │
│  └── Settings (Mode selection, Model management)    │
├─────────────────────────────────────────────────────┤
│  Service Layer                                       │
│  ├── TranscriptionService (Hybrid routing)          │
│  └── WhisperLocalService (whisper.cpp FFI)          │
├─────────────────────────────────────────────────────┤
│  Data Layer                                          │
│  ├── TranscriptionResult (Word-level data)          │
│  └── Export (SRT, ASS, JSON)                        │
└─────────────────────────────────────────────────────┘
         │                        │
         ├────────────┬───────────┘
         │            │
    ┌────▼────┐  ┌───▼────────┐
    │ Local   │  │   Cloud    │
    │ whisper │  │  FastAPI   │
    │  .cpp   │  │  Backend   │
    └─────────┘  └────────────┘
```

---

## Prerequisites

### Development
- Flutter SDK 3.0+
- Android Studio / Xcode
- Python 3.9+ (for backend)
- FFmpeg (for audio extraction)

### For On-Device Transcription
- whisper.cpp native library
- Model files (tiny/base/small/medium)

### For Huawei Distribution
- Huawei Developer Account
- AppGallery Connect access

---

## Quick Start

### 1. Install Dependencies
```bash
cd mobile_transcription
flutter pub get
```

### 2. Configure Backend (Optional)
Update cloud API URL in `lib/services/transcription_service.dart`:
```dart
static const String DEFAULT_CLOUD_URL = 'http://YOUR_SERVER:8000';
```

### 3. Run the App
```bash
flutter run
```

---

## Build for Release

### Android APK (Universal)
```bash
flutter build apk --release
```

### Android APK (Split by ABI - smaller files)
```bash
flutter build apk --release --split-per-abi
```
Output:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit x86)

### Android App Bundle (AppGallery)
```bash
flutter build appbundle --release
```

---

## Transcription Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| **Auto** | Prefers local, falls back to cloud | Default recommendation |
| **On-Device** | Uses whisper.cpp only | Offline, privacy-sensitive |
| **Cloud** | Uses FastAPI backend | Faster, longer videos |

---

## Export Formats

### SRT (Standard Subtitles)
- Compatible with all video players
- Segment-level timing

### ASS (Advanced Substation Alpha)
- **Karaoke-style word animations**
- Custom fonts, colors, positioning
- Best for "Hormozi-style" captions

### JSON (Editor Format)
- Word-level timestamps
- Import into custom editors
- Remotion/web integration

---

## Huawei AppGallery Setup

See [HUAWEI_SETUP.md](HUAWEI_SETUP.md) for detailed instructions.

### Quick Checklist
1. [ ] Create app in AppGallery Connect
2. [ ] Download `agconnect-services.json`
3. [ ] Update App ID in build.gradle and AndroidManifest.xml
4. [ ] Enable HMS Core services
5. [ ] Build AAB: `flutter build appbundle --release`
6. [ ] Upload to AppGallery Connect

---

## Project Structure

```
mobile_transcription/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── transcription_result.dart # Data models
│   ├── services/
│   │   ├── transcription_service.dart # Hybrid routing
│   │   └── whisper_local_service.dart # On-device AI
│   ├── ui/
│   │   ├── home_screen.dart          # Upload & settings
│   │   ├── caption_editor_screen.dart # Word-level editor
│   │   └── settings_screen.dart      # App settings
│   └── utils/
│       └── theme.dart                # App theming
├── android/
│   ├── app/
│   │   ├── build.gradle              # Android build config
│   │   ├── agconnect-services.json   # Huawei config
│   │   └── proguard-rules.pro        # Release optimization
│   └── ...
├── assets/
│   └── whisper_models/               # Downloaded AI models
└── pubspec.yaml                      # Flutter dependencies
```

---

## Performance Optimization

### APK Size Reduction
- Use `--split-per-abi` for architecture-specific APKs
- Download models on-demand (not bundled)
- Enable ProGuard minification

### Transcription Speed
| Model | Size | Speed (60s audio) | Accuracy |
|-------|------|-------------------|----------|
| Tiny  | 40 MB  | ~15s (mobile)     | ~50%     |
| Base  | 140 MB | ~30s (mobile)     | ~70%     |
| Small | 450 MB | ~60s (mobile)     | ~85%     |
| Medium| 1.5 GB | ~120s (mobile)    | ~95%     |

### Memory Management
- Large heap enabled in manifest
- ProGuard rules for tree-shaking
- Lazy loading for models

---

## API Reference

### TranscriptionService

```dart
// Initialize
await transcriptionService.initialize();

// Set mode
await transcriptionService.setMode(TranscriptionMode.local);

// Transcribe video
final result = await transcriptionService.transcribe(
  videoFile,
  onProgress: (progress) {
    print('Progress: ${progress * 100}%');
  },
);

// Export
final srt = result.toSRT();
final ass = result.toASS();
final json = result.toJsonExport();
```

---

## Troubleshooting

### "Model not downloaded"
- Go to Settings → On-Device Model → Download Base Model
- Ensure stable internet connection

### "Cloud transcription failed"
- Check server URL in Settings
- Verify backend is running: `http://YOUR_SERVER:8000/health`

### "App crashes on video upload"
- Check storage permissions
- Ensure video format is MP4/MOV/WebM

### "HMS services not working"
- Install HMS Core from AppGallery
- Verify `agconnect-services.json` is correct

---

## Roadmap

- [ ] Real-time caption preview on video
- [ ] In-app caption styling editor
- [ ] Direct social media export (TikTok, Instagram)
- [ ] Multi-language support
- [ ] Voice activity detection (VAD) for cleaner transcripts
- [ ] Speaker diarization (multiple speakers)

---

## License

MIT License - See LICENSE file for details.

---

## Support

- Issues: GitHub Issues
- Email: support@viralcaption.ai
- Documentation: https://viralcaption.ai/docs
