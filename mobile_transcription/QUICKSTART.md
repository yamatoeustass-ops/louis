# Quick Start Guide

## 1. Install Flutter

### Linux/macOS
```bash
# Using snap (Linux)
sudo snap install flutter --classic

# Or download from https://docs.flutter.dev/get-started/install
```

### Verify Installation
```bash
flutter doctor
```

---

## 2. Clone & Setup

```bash
cd mobile_transcription
flutter pub get
```

---

## 3. Run the App

### Connect Device
- Android: Enable USB debugging, connect via USB
- Emulator: Start Android Studio emulator

### Run
```bash
# Debug mode
flutter run

# Or use the script
./scripts/run.sh
```

---

## 4. Build Release APK

```bash
# Build for all architectures
./scripts/build.sh split

# Or manually
flutter build apk --release --split-per-abi
```

APKs will be in: `build/app/outputs/flutter-apk/`

---

## 5. Configure Cloud Backend (Optional)

Edit `lib/services/transcription_service.dart`:

```dart
static const String DEFAULT_CLOUD_URL = 'http://YOUR_SERVER_IP:8000';
```

Or change in-app via Settings → Cloud URL.

---

## 6. Enable On-Device Transcription

### Download whisper.cpp library

See [WHISPER_INTEGRATION.md](WHISPER_INTEGRATION.md) for detailed instructions.

Quick version:
```bash
# Download pre-built libraries
cd android/app/src/main
mkdir -p jniLibs/arm64-v8a
# Download libwhisper.so from whisper.cpp releases
```

### Download Model
1. Open app
2. Go to Settings
3. Tap "Download Base Model" (~140 MB)

---

## 7. Huawei AppGallery Setup

See [HUAWEI_SETUP.md](HUAWEI_SETUP.md) for complete guide.

Quick checklist:
1. Create app in AppGallery Connect
2. Download `agconnect-services.json`
3. Place in `android/app/`
4. Build AAB: `flutter build appbundle --release`
5. Upload to AppGallery

---

## Troubleshooting

### "No devices found"
```bash
flutter devices
adb devices  # Check Android connection
```

### "Build failed"
```bash
flutter clean
flutter pub get
flutter build apk
```

### "HMS error"
- Normal on non-Huawei devices (app still works)
- HMS is optional for cloud transcription

---

## Next Steps

1. Test with a sample video
2. Configure your cloud backend URL
3. Download whisper model for offline mode
4. Build release APK for distribution

---

## Useful Commands

```bash
flutter doctor          # Check setup
flutter devices         # List connected devices
flutter pub get         # Install dependencies
flutter clean           # Clean build
flutter analyze         # Check code
flutter test            # Run tests
flutter build apk       # Build APK
```

---

## Support

- Docs: See `/mobile_transcription/README.md`
- Issues: Check console logs with `flutter logs`
