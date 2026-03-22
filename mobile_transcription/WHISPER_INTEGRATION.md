# Whisper.cpp Integration Guide

## Overview

This app uses [whisper.cpp](https://github.com/ggerganov/whisper.cpp) for efficient on-device transcription. whisper.cpp is a C/C++ port of OpenAI Whisper optimized for mobile CPUs.

---

## Option 1: Pre-built Native Library (Recommended)

### Step 1: Download whisper.cpp Android Libraries

```bash
cd android/app/src/main
mkdir -p jniLibs/armeabi-v7a jniLibs/arm64-v8a jniLibs/x86_64
```

Download pre-built libraries from whisper.cpp releases:
```bash
# ARM 64-bit (most modern Android phones)
curl -L https://github.com/ggerganov/whisper.cpp/releases/download/v1.6.0/whisper-android-aarch64.tar.gz \
  | tar -xz -C android/app/src/main/jniLibs/arm64-v8a

# ARM 32-bit (older phones)
curl -L https://github.com/ggerganov/whisper.cpp/releases/download/v1.6.0/whisper-android-armeabi-v7a.tar.gz \
  | tar -xz -C android/app/src/main/jniLibs/armeabi-v7a
```

### Step 2: Update pubspec.yaml

Add FFI dependency:
```yaml
dependencies:
  ffi: ^2.1.0
  ffigen: ^11.0.0
```

### Step 3: Generate FFI Bindings

Create `ffigen.yaml`:
```yaml
name: WhisperCpp
description: FFI bindings for whisper.cpp
output: 'lib/whisper_cpp_bindings.dart'
headers:
  entry-points:
    - 'android/app/src/main/jniLibs/include/whisper.h'
compiler-opts:
  - '-Iandroid/app/src/main/jniLibs/include'
```

Run:
```bash
flutter pub run ffigen
```

---

## Option 2: Build whisper.cpp from Source

### Prerequisites
- Android NDK r21+
- CMake 3.10+

### Build Script

Create `scripts/build_whisper_android.sh`:

```bash
#!/bin/bash

WHISPER_REPO="https://github.com/ggerganov/whisper.cpp.git"
WHISPER_VERSION="v1.6.0"
ANDROID_NDK=$ANDROID_NDK_HOME

# Clone whisper.cpp
git clone $WHISPER_REPO
cd whisper.cpp
git checkout $WHISPER_VERSION

# Build for ARM64
mkdir -p build_android_arm64
cd build_android_arm64

cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-24 \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_TESTS=OFF \
  -DWHISPER_BUILD_EXAMPLES=OFF

make -j8

# Copy library
cp libwhisper.so ../../android/app/src/main/jniLibs/arm64-v8a/
```

---

## Option 3: Use Flutter Plugin (Easiest)

Add to `pubspec.yaml`:

```yaml
dependencies:
  whisper_flutter: ^1.0.0  # Community plugin
```

Or use process channel with whisper.cpp CLI:

```yaml
dependencies:
  process_run: ^0.12.0
```

---

## Model Download

Models are downloaded from HuggingFace at runtime:

```dart
final service = WhisperLocalService();
await service.downloadModel('base'); // Downloads ~140MB
```

Model sizes:
| Model | Size | RAM Usage |
|-------|------|-----------|
| tiny  | 40 MB  | ~300 MB   |
| base  | 140 MB | ~500 MB   |
| small | 450 MB | ~1 GB     |
| medium| 1.5 GB | ~2 GB     |

---

## Testing

### Unit Test
```bash
flutter test test/transcription_test.dart
```

### Integration Test
```bash
flutter test integration_test/
```

### On Device
```bash
flutter run --release
```

---

## Performance Tips

1. **Use ARM64 builds** - 2-3x faster than ARM32
2. **Download models to external storage** - Save internal storage space
3. **Use tiny/base models** - Better mobile performance
4. **Enable NNAPI** - Hardware acceleration on supported devices

---

## Troubleshooting

### "Cannot load library libwhisper.so"
Ensure the .so file is in the correct `jniLibs` folder for your ABI.

### "Model file not found"
Models are downloaded to `/data/data/com.viralcaption.viral_caption/files/whisper_models/`

### "Out of memory"
Use smaller models (tiny/base) or increase heap size in manifest.
