# Huawei AppGallery Connect Setup Guide

## Prerequisites

1. **Huawei Developer Account**: Register at [developer.huawei.com](https://developer.huawei.com)
2. **AppGallery Connect Account**: Access at [appgalleryconnect.huawei.com](https://appgalleryconnect.huawei.com)

---

## Step 1: Create Your App in AppGallery Connect

1. Log in to [AppGallery Connect](https://appgalleryconnect.huawei.com)
2. Click **My apps** → **Create app**
3. Fill in:
   - **App name**: ViralCaption AI
   - **Package name**: `com.viralcaption.viral_caption`
   - **Category**: Photo & Video
   - **Icon**: Upload your app icon (1024x1024 PNG)

4. Click **Submit**

---

## Step 2: Configure App Information

### Basic Info
- Go to **App information** → **Basic information**
- Fill in:
  - Short description (max 80 characters)
  - Full description (max 4000 characters)
  - Screenshots (minimum 3 for phone)
  - Feature graphic (1024x500 PNG)

### Privacy & Compliance
- Upload Privacy Policy URL
- Complete the compliance questionnaire
- Add EULA if required

---

## Step 3: Download agconnect-services.json

1. In AppGallery Connect, go to **Project Settings** → **General**
2. Under **Your apps**, find your Android app
3. Click **Download agconnect-services.json**
4. Replace the placeholder file at:
   ```
   android/app/agconnect-services.json
   ```

---

## Step 4: Update Configuration Files

### android/app/build.gradle
Replace the placeholder:
```gradle
manifestPlaceholders = [
    HUAWEI_APP_ID: "YOUR_ACTUAL_APP_ID_FROM_AGC"
]
```

### android/app/src/main/AndroidManifest.xml
Replace:
```xml
<meta-data
    android:name="com.huawei.hms.client.appid"
    android:value="appid=YOUR_ACTUAL_APP_ID" />
```

---

## Step 5: Enable Required Services

In AppGallery Connect:

### HMS Core Services
1. Go to **Grow** → **HMS Core**
2. Enable:
   - **Account Kit** (for Huawei login)
   - **In-App Purchases** (if adding premium features)
   - **Push Kit** (for notifications)
   - **Analytics** (for usage tracking)

### App Signing
1. Go to **Release** → **App signing**
2. Choose:
   - **Use existing signing key** (if you have one)
   - **Generate new signing key** (recommended for new apps)

---

## Step 6: Build Release APK/AAB

### Generate Upload Keystore
```bash
keytool -genkey -v -keystore viral_caption.keystore \
  -alias viral_caption -keyalg RSA -keysize 2048 -validity 10000
```

### Update key.properties
Create `android/key.properties`:
```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=viral_caption
storeFile=../viral_caption.keystore
```

### Build Commands

**Universal APK (all architectures):**
```bash
flutter build apk --release --split-per-abi
```

**Android App Bundle (recommended for AppGallery):**
```bash
flutter build appbundle --release
```

Output files:
- APK: `build/app/outputs/flutter-apk/`
- AAB: `build/app/outputs/bundle/release/`

---

## Step 7: Upload to AppGallery

1. In AppGallery Connect, go to **Release** → **App releases**
2. Click **Submit** for the release type (e.g., Formal Release)
3. Upload your AAB or APK file
4. Fill in release notes
5. Select countries/regions for distribution
6. Click **Submit for review**

---

## Step 8: App Review & Publishing

- Review typically takes 1-3 business days
- Monitor status in **Release** → **App releases**
- Once approved, the app will be published to AppGallery

---

## Direct APK Distribution (Sideloading)

For direct distribution outside AppGallery:

1. Build universal APK:
   ```bash
   flutter build apk --release
   ```

2. Distribute via:
   - Your website
   - Email
   - QR code download
   - Third-party app stores

3. Users enable "Install from Unknown Sources" in Android settings

---

## Testing on Huawei Devices

### Before Submission
1. Enable **Developer mode** on Huawei device
2. Enable **USB debugging**
3. Install via ADB:
   ```bash
   flutter run --release
   ```

### HMS Core Verification
1. Ensure HMS Core is installed on the device
2. Test HMS services (Account Kit, Push, etc.)
3. Check logs for any HMS-related errors

---

## Common Issues & Solutions

### Issue: "App ID not found"
**Solution**: Ensure `agconnect-services.json` is in `android/app/` and App ID matches

### Issue: HMS services not working
**Solution**: Install/update HMS Core from AppGallery

### Issue: Build fails with ProGuard errors
**Solution**: Add HMS keep rules to `proguard-rules.pro`

### Issue: App crashes on startup
**Solution**: Check logcat for missing permissions or native library issues

---

## Useful Links

- [AppGallery Connect Documentation](https://developer.huawei.com/consumer/en/doc/appgallery-connect-guides)
- [HMS Core Integration Guide](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides)
- [AppGallery Review Guidelines](https://developer.huawei.com/consumer/en/doc/appgallery-connect-guides/agc-review-guidelines)
- [Huawei Developer Forum](https://forums.developer.huawei.com/)

---

## Contact Support

- Email: developer.support@huawei.com
- Forum: https://forums.developer.huawei.com/
